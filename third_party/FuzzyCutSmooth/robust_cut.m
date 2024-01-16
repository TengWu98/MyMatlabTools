function [ver_pos_opt] = robust_cut(Data, para)
% Data.initial_patch_ids;
% Data.patch_coords
% Data.active_vids (only those vertices can be on the boundary)
% Data.graph
% para.weight_vertex_min
% para.weight_vertex_max
% para.alpha_min
% para.alpha_max
% para.num_iterations

% Initialize the vertex positions
ver_pos_init = Data.patch_coords(:, Data.initial_patch_ids); % 将每个face对应到其所在patch对应的3D的coord，
dim = size(ver_pos_init, 1); % ver_pos的维数
nv = size(ver_pos_init, 2);  % ver_pos的个数，即为face数
ver_pos_init = reshape(ver_pos_init, [dim*nv, 1]); % 将所有ver_pos存成一列dim*nv,成的数组
ver_pos_opt = ver_pos_init; 

% Return if we just have one segment
num_patches = max(Data.initial_patch_ids);
if num_patches < 2
    return;
end

% Precomputation for edge terms
[v1_ids, v2_ids, edge_w] = find(Data.graph); % v1_ids和v2_ids相邻，edge_w为连接两个face的边的权重
ids = find(v1_ids < v2_ids);
v1_ids = v1_ids(ids); % v1_ids为长为ne的数组
v2_ids = v2_ids(ids); % v2_ids为长为ne的数组
edge_w = edge_w(ids);

ne = length(v1_ids); % 边的条数
rows_G = kron(1:(dim*ne), ones(1, 2*dim)); % 长度dim*ne*2*dim的数组，2*dim个1,2*dim个2,...,2*dim个(dim*ne)

% 注：(v1_ids(1)-1)*dim+1,+2,...,+dim为指标为v1_ids(1)对应的coord
tp = kron([v1_ids'; v2_ids']-1, dim*ones(dim, dim)); % 为(2*ne*dim)*(dim)的矩阵, 每一列都相同，对应的是([v1_ids'; v2_ids']-1)*dim
cols_G = reshape(tp, [1,2*dim*dim*ne]) + kron(ones(1, 2*dim*ne), 1:dim); % 将dim组相同的数据排成一行
% 同样变成长度dim*ne*2*dim的数组，结果为dim组相同的数据排成的一列
% 每组对应的是v1_ids和v2_ids每个v对应的coord在ver_pos_opt中的指标，即cols_G将v1_ids和v2_ids每个v对应的coord指标排序后重复dim次


active_var_ids = dim*kron(Data.active_vids-1, ones(1, dim))...
    + kron(ones(1, length(Data.active_vids)), 1:dim);
% Data.active_vids对应的coord在ver_pos_opt中的指标，长度为length(Data.active_vids)*dim


% Apply Gauss-Newton method 干嘛用？？？？
for iteration = 0 : para.num_iterations
    % Set parameters
    if iteration == 0
        alpha = 0;
        lambda = 0;
    else
        t = (iteration - 1)/(para.num_iterations-1); % t为0-1，共迭代para.num_iterations步
        lambda = exp(-10*t); % lambda开始为1，后来慢慢变小
        alpha = exp((1-t)*log(para.alpha_min)... % alpha是para.alpha_min和para.alpha_max的凸组合
            + t*log(para.alpha_max));
    end
   
    tp = reshape(ver_pos_opt, [dim, nv]);
    res = tp(:, v1_ids) - tp(:, v2_ids); % 相邻两个face的coord的差
    
    if dim > 1
        tp = (1 + alpha*sum(res.*res)); % 记录每两个face的欧氏距离的平方s，tp=1+alpha*s
    else
        tp = 1 + alpha*(res.*res);
    end
    scale1 = sqrt(edge_w)' ./ power(tp, 0.5); 
    scale2 = (scale1 ./ tp)*alpha;
    
    tp = kron(res, ones(1, dim)).*...
        kron(reshape(res, [1, ne*dim]), ones(dim, 1));
    
    vals_G = kron(scale1, [eye(dim); -eye(dim)])...
        - kron(scale2, ones(2*dim, dim)).*[tp;-tp];
   
    vals_G = reshape(vals_G, [1, dim*dim*2*ne]);
    G = sparse(rows_G, cols_G, vals_G);
    
    num_vars = length(active_var_ids);
    
    G = G(:, active_var_ids);
    c = reshape(res, [dim*ne,1]).*kron(scale1', ones(dim,1));
    
    H = sparse(1:num_vars, 1:num_vars, ones(1, num_vars))*lambda;
    
    dx = -(G'*G+H)\(G'*c);
    
    ver_pos_opt(active_var_ids) = ver_pos_opt(active_var_ids) + dx;
    
    if norm(dx) < 1e-6
        break;
    end
    if iteration < para.num_iterations || iteration == para.num_iterations
        deviation = sum(sum(abs(ver_pos_opt - ver_pos_init)));
%         fprintf('alpha = %f, norm(dx) = %f, deviation = %f.\n',...
%             alpha, norm(dx), deviation);
    end
end

ver_pos_opt = reshape(ver_pos_opt, [dim, nv]);
