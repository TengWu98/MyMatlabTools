function smooth_hie(dir, filename)
% 将单个模型的分割结果边界进行smooth
% dir：模型所在文件夹目录
% filename：模型分割结果名称

%% face_cluster
% 读取模型名称和分割数
idx = strfind(filename,'_');
model_name = filename(1:(idx(1)-1));
patch_num = str2double(filename((idx(1)+1):(idx(2)-1)));

% 读取patch_cluster文件，即之前的结果文件
fid_pc = fopen([dir,'\',filename,'.txt'],'r');
X_temp = textscan(fid_pc, '%d');
fclose(fid_pc);
patch_cluster = X_temp{1};

% 读取face_patch文件
name_fp = [model_name,'_',num2str(patch_num)];
fid_fp = fopen([dir,'\',name_fp,'.txt'],'r');
X_temp = textscan(fid_fp, '%d');
fclose(fid_fp);
face_patch = X_temp{1} + 1;

% 得到face_cluster, 即每个face对应的cluster指标，用于对refine_seg之后的指标映射回原来的指标
face_cluster = patch_cluster(face_patch);
clear patch_cluster face_patch

%% smooth
% Parameters
Para.minEdgeWeight = 0.1;               % minimum edge weights
Para.alphaAngle = 0.33;                 % Used in make the edge weights more uniformly distributed
Para.half_brush_width = 10;

% load model
[model] = loadfobj([dir,'\',model_name,'.obj']);
% Compute edge weights based on concavity
edgeConcavityWeights = compute_angle_weights(model);
% Smooth the edge concavity weights
edgeConcavityWeights = power(edgeConcavityWeights, Para.alphaAngle);
% Edge weights, the smaller, the better
edgeWeights = 1 - (1- Para.minEdgeWeight)*edgeConcavityWeights;

% Perform hierachical clustering， 网格各个face作为结点
graph = [double(model.edge_fids); edgeWeights];
% 读取face_segment文件,face_patchids,即每个面片对应的segment指标
fid_fs = fopen([dir,'\',filename,'.fs'],'r');
X_temp = textscan(fid_fs, '%f');
fclose(fid_fs);
seg.face_patchids = X_temp{1}+1;

% 根据网格的拓扑关系和每个face对应的segment指标，求出每个face对应的depth
% depth代表的是每个面片从所属segment边界蔓延到它所过圈数
facedepth = boundarydistance(int32(model.edge_fids-1),...
    int32(seg.face_patchids'-1));
num_faces = length(seg.face_patchids);
num_patches = max(seg.face_patchids(:));
patch_centerids = zeros(1, num_patches); % 记录每个segment的center
active_vids = zeros(1, num_faces); % 若face对应的active_vids是1，则其对应的segment指标可变 
for patch_id = 1 : num_patches
    ids = find(seg.face_patchids == patch_id);
    [max_patch_depth, max_id] = max(facedepth(ids)); % 每个segment中depth最大的face以及其depth值
    patch_centerids(patch_id) = ids(max_id); % 每个segment的center是depth最大的face
    active_vids(ids(find(facedepth(ids)<max_patch_depth/2))) = 1; % 若depth小于max/2，则标记为active
    active_vids(patch_centerids(patch_id)) = 0; % 将center标记为inactive
    active_vids(find(facedepth > Para.half_brush_width)) = 0; % 将depth值大于para.half_brush_width也标记为inactive
end
seg.face_patchids = hie_clus_new(graph, active_vids, seg.face_patchids' , num_patches);


%% 将refine_seg之后的指标映射回原来的指标
seg_num = max(seg.face_patchids);
mapping = zeros(1,seg_num);
idxs = cell(1,seg_num);
for i = 1:seg_num
    idxs{i} = seg.face_patchids == i;
    [B,I,J] = unique(face_cluster(idxs{i}));
    n = length(B);
    max_num = 0;
    idx = 0;
    for j=1:n
        m = sum(J==j);
        if m > max_num
            idx = B(j);
            max_num = m;
        end
    end
    mapping(i) = idx;
end
for i = 1:seg_num
    seg.face_patchids(idxs{i}) = mapping(i);
end
clear idxs

%% 将refine后的结果输出
output_name = [filename,'_refin_'];
fid=fopen([dir,'\',output_name,'.txt'],'wt');
for i=1:length(seg.face_patchids)
    fprintf(fid,'%d\n',seg.face_patchids(i));
end
fclose(fid);

function [edgeConcavityWeights] = compute_angle_weights(model)

vertexPos1 = model.vertex_pos(:, model.face_vids(1,:));
vertexPos2 = model.vertex_pos(:, model.face_vids(2,:));
vertexPos3 = model.vertex_pos(:, model.face_vids(3,:));

faceCenters = (vertexPos1 + vertexPos2 + vertexPos3)/3;

thetas = sum(model.face_nor(:, double(model.edge_fids(1,:)))...
    .*model.face_nor(:, double(model.edge_fids(2,:))));
thetas = acos(max(min(thetas, 1), -1));

edgeConcavityWeights = min(1, thetas);
edgeConcavityWeights = edgeConcavityWeights/max(edgeConcavityWeights);

%only concave edges
edges = faceCenters(:, double(model.edge_fids(1,:)))-...
    faceCenters(:, double(model.edge_fids(2,:)));

inner1 = -sum(edges.*model.face_nor(:, model.edge_fids(1,:)));
inner2 = sum(edges.*model.face_nor(:, model.edge_fids(2,:)));

edgeConcavityWeights(find(inner1 + inner2 < 0)) = 0;