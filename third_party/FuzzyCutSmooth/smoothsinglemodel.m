function [ret] = smoothsinglemodel(vectex, faces, label_name, neighbour_name, param)
% 将单个模型的分割结果边界进行smooth,这里的结果直接是直接相对于面片的
% dir：模型所在文件夹目录
% filename：模型分割结果名称
% param.width：para.half_brush_width，用于控制可变segment指标的面片范围
% param.alpha_min和 param.alpha_max：alpha的范围，高斯牛顿法中的参数
% param.iter：高斯牛顿法中得迭代步数
% param.iter_all：进行refine_seg的次数
% param.S：segment之间的相似矩阵
%param.sigma_angle 
%param.num_iterations
% 因为现在界面和代码分离，不能直接看到运行结果，所有没办法确定smooth的次数，
% 只能反复修改，而不能在原来的结果上直接做（为这个写了一个代码smooth_single_face），
% 但是同样也只能处理只smooth过一次的网格，主要原因是smooth结果是根据参数命名的

% 读取模型
model = generate_mesh(vectex, faces);

% 读取face_segment文件,face_patchids,即每个面片对应的segment指标
fid_fs = fopen(label_name, 'r');
X_temp = textscan(fid_fs, '%d');
fclose(fid_fs);
seg.face_patchids = X_temp{1}+1;

% patch_adj_mat: 记录segment间的相邻情况
fid_fs = fopen(neighbour_name, 'r');
X_temp = textscan(fid_fs, '%d %d');
fclose(fid_fs);

num_segments = max([X_temp{1}', X_temp{2}']) + 1;
idx = sub2ind([num_segments num_segments], X_temp{1}+1, X_temp{2}+1);
sc = zeros(num_segments, num_segments);
sc(idx) = 1;
seg.patch_adj_mat = sc' + sc;
% 这里我们还加入了相似信息
%if nargin == 4
%    seg.patch_adj_mat = seg.patch_adj_mat + S / max(S(:));
%end

% refine_seg
l = 0;
for i = 1:param.iter_all
    [~, seg, len] = refine_seg(model, seg, param, i, l);
    if i == 1
        l = len;
    end
end
seg_refined = seg;

%结果
ret = seg_refined.face_patchids;
