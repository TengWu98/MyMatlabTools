function [face_patchids_opt] = refine_partition(model, seg, para)
% refine的主程序，输出为更新后的每个face对应的segment指标

% segment数目
num_patches = max(seg.face_patchids);
if num_patches > 1000 || num_patches < 2
    face_patchids_opt = seg.face_patchids;
    return;
end

% face对应的初始segment指标
Data.initial_patch_ids = seg.face_patchids;

% 根据segment间的连接矩阵，将他们embed到另一个空间上，（这里是3D），每个segment对应一个点
if size(seg.face_patchids,1) < size(seg.face_patchids,2) % seg.face_patchids为列向量
    seg.face_patchids = seg.face_patchids';
end

% 根据网格的拓扑关系和每个face对应的segment指标，求出每个face对应的depth
% depth代表的是每个面片从所属segment边界蔓延到它所过圈数
facedepth = boundarydistance(int32(model.edge_fids-1),...
    int32(seg.face_patchids'-1));

num_faces = length(seg.face_patchids);
Data.patch_centerids = zeros(1, num_patches); % 记录每个segment的center

Data.active_vids = zeros(1, num_faces); % 若face对应的active_vids是1，则其对应的segment指标可变 
for patch_id = 1 : num_patches
    ids = find(seg.face_patchids == patch_id);
    [max_patch_depth, max_id] = max(facedepth(ids)); % 每个segment中depth最大的face以及其depth值
    Data.patch_centerids(patch_id) = ids(max_id); % 每个segment的center是depth最大的face
    Data.active_vids(ids(find(facedepth(ids)<max_patch_depth/2))) = 1; % 若depth小于max/2，则标记为active
    Data.active_vids(Data.patch_centerids(patch_id)) = 0; % 将center标记为inactive
    Data.active_vids(find(facedepth > para.half_brush_width)) = 0; % 将depth值大于para.half_brush_width也标记为inactive
end
Data.active_vids = find(Data.active_vids == 1);% Data.active_vids记录active的face指标

% do graph embedding, compute the optimal coordinate of each patch
% 将每个patch对应到3D空间上去，谱分析
Data.patch_coords = graph_embedding(seg.patch_adj_mat); 

% 网格的拓扑结果，将所有面看成node，构成一张graph
Data.graph = sparse(double(model.edge_fids(1, :)),...
    double(model.edge_fids(2, :)),...
    ones(1,size(model.edge_fids, 2)));
%graph = graph*graph;
[v1_ids, v2_ids, edge_w] = find(Data.graph); % 网格face间的连接关系，其实就是将model.edge_fids重新排序

flags = zeros(num_faces, 1); % 将active的face的flag设为1
flags(Data.active_vids) = 1;
ids = find(v1_ids < v2_ids & (flags(v1_ids) > 0 | flags(v2_ids) > 0)); % ids记录的是两个顶点至少有一个active的边的指标
v1_ids = v1_ids(ids);
v2_ids = v2_ids(ids);  % 至少有一个face是active的边的指标组

v1_nor = model.face_nor(:, v1_ids); % 上述face对应的normal
v2_nor = model.face_nor(:, v2_ids);
v1_pos = model.face_centers(:, v1_ids); % 上述face对应的中心点
v2_pos = model.face_centers(:, v2_ids);

angles = acos(max(min(sum(v1_nor.*v2_nor),1),-1)); % 这些相邻face之间的法向夹角

% weight the angle based 
% 计算每条边的长度，归一化
edge_dis = model.vertex_pos(:, model.edge_vids(1,:)) - model.vertex_pos(:, model.edge_vids(2,:));
edge_len = sqrt(sum(edge_dis.*edge_dis));
edge_len = edge_len/max(edge_len);
edge_len = edge_len(ids');

% concave regions
% 凹的话inner>0，将凹的边angle设为1， angle的取值在-1和1之间，angle越大说明面的法向夹角越大
inner = sum((v2_pos - v1_pos).*v1_nor) + sum((v1_pos - v2_pos).*v2_nor);
angles(find(inner < 0)) = 0;

% weight curveness
% 定义这些相邻face之间边的权重，与角度成反比，两面的夹角越小他们之间的edge_w就越大，
% 与边长成正比，两面相连越多权重也就越大
edge_w = exp(-angles/para.sigma_angle).*edge_len;

for i=1:length(edge_w)
    Data.graph(v1_ids(i),v2_ids(i)) = edge_w(i);
end
% Perform robust-cut
% 将每个face映射到segment所embeded的空间上
% 主要是更新active的face对应的segment指标
ver_pos_opt = robust_cut(Data, para); 

face_patchids = seg.face_patchids; % 每个face初始对应的segment指标
face_patchids(Data.active_vids) = 0; % 将active的face对应segment指标设为0
face_patchids_opt = finishsegmentation(int32(model.edge_fids-1),...  % 优化每个face对应的segment指标
    ver_pos_opt, int32(Data.patch_centerids-1),...
    int32(face_patchids-1));
% 实际上就是定义了每个face到patch的距离，inactive的face到所属segment距离都为0，然后这些距离被存在queue，因此这些face和segment对
% 最先跳出queue，对于那些active的face，则通过其相邻的face pop出queue的时候进queue
