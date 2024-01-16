% [tr_dat, tt_dat, latent] = szy_PreprocessingData_ForDL(tr_Samples, tt_Samples, epsilon, isUseZCAWhitening, isMapMinMax)
% 注意这里epsilon的选择问题：按照UFLDL中的建议，应该让epsilon大于绝大多数latent
% 后面的很小的那些尾巴值。所以，使用本函数的时候，请先运行一下，然后画出latent的
% 曲线图，人工看一下epsilon该选成多大，然后用选中的epsilon值再次运行一次，
% 得到最终结果Result。
function [tr_dat, tt_dat, latent] = szy_PreprocessingData_ForDL(tr_Samples, tt_Samples, epsilon, isUseZCAWhitening, isMapMinMax)
% 按照UFLDL建议，为了防止分母出现0，所以加一个很小的epsilon到分母
if exist('epsilon', 'var') ~= 1
    epsilon = 0;
end

if exist('isUseZCAWhitening', 'var') ~= 1
    isUseZCAWhitening = true;
end

if exist('isMapMinMax', 'var') ~= 1
    isMapMinMax = false;
end

% 通过实验发现，做以下这第1步似乎反而会稍微降低非常小一点点的准确率。
if isMapMinMax
    Y = mapminmax(tr_Samples', 0, 1);
else
    Y = tr_Samples';
end

% 这一步是我的onenote笔记中说的第2步，不需要了，因为第3步已经包含了。
% Z = zscore(Y);

if isUseZCAWhitening
    % 通过实验发现，ZCA能比PCA效果更好。
    [tr_dat, tt_dat, latent] = szy_ZCAWhitening(Y', tt_Samples, epsilon);
else
    [tr_dat, tt_dat, latent, ~] = szy_PCAWhitening(Y', tt_Samples, epsilon);
end
end