function [pred_lb, R, X] = szy_SRC2(tr_dat, tr_lb, tt_dat, lambda, rel_tol)
% [pred_lb, R, X] = szy_SRC(tr_dat, tr_lb, tt_dat, lambda, rel_tol)
% 用稀疏表示分类器进行分类。tr_dat表示训练样本，每一列表示一个样本，
% tr_lb是每个训练样本的已知类别，是行向量，tt_dat表示测试样本，每一列一个样本，
% 参数lambda，默认值为0.01，rel_tol，默认值为0.01。
% pred_lb表示分类结果，是行向量，R表示稀疏表示的残差，每一列对应一个测试样本
% 在各类训练样本上的残差。
% 本函数由舒振宇撰写。

if nargin < 5
    rel_tol = 0.01;  % regularization parameter
end
if nargin < 4
    lambda = 0.01;   % relative target duality gap
end
% 稀疏表示
X = [];
for i = 1:size(tt_dat, 2)
    y = tt_dat(:, i);
    disp(['稀疏表示第', int2str(i), '个测试样本...']);
    [x, status]=l1_ls(tr_dat, y, lambda, rel_tol, 1);
    if strcmp(status, 'Solved') == 0
        disp('L1最小化错误！');
    end
    X(:,i) = x;
end

% 计算残差
R = [];
uniquelabels = unique(tr_lb);
c = max(size(uniquelabels));
for j = 1:c
    index = find(tr_lb == uniquelabels(j));
    temp = tt_dat - tr_dat(:, index) * X(index,:);
    R(j,:) = sqrt(sum(temp.*temp));
end
[minR,indices] = min(R);

% 暂时注释。。。
pred_lb = [];
% pred_lb = uniqlabels(indices);

end