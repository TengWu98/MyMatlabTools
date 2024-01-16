% [tr_dat, tt_dat, latent, coeff] = szy_PCAWhitening(tr_Samples, tt_Samples, epsilon)
% 注意这里epsilon的选择问题：按照UFLDL中的建议，应该让epsilon大于绝大多数latent
% 后面的很小的那些尾巴值。所以，使用本函数的时候，请先运行一下，然后画出latent的
% 曲线图，人工看一下epsilon该选成多大，然后用选中的epsilon值再次运行一次，
% 得到最终结果Result。
function [tr_dat, tt_dat, latent, coeff] = szy_PCAWhitening(tr_Samples, tt_Samples, epsilon)
% 按照UFLDL建议，为了防止分母出现0，所以加一个很小的epsilon到分母
if exist('epsilon', 'var') ~= 1
    epsilon = 0;
end

[coeff, score, latent] = pca(tr_Samples');
% [coeff, score, latent] = pca(AllSamples', 'Economy',false);
% AllSamples_R = score * coeff';
% AllSamples_R = AllSamples_R; + repmat(mu, size(AllSamples_R, 1), 1);
% epsilon = ;
tr_dat = score ./ repmat(sqrt(latent' + epsilon), size(score, 1), 1);
tr_dat = tr_dat';

temp = tt_Samples - repmat(mean(tr_Samples, 2), 1, size(tt_Samples, 2));
score2 = temp' * coeff;

tt_dat = score2 ./ repmat(sqrt(latent' + epsilon), size(score2, 1), 1);
tt_dat = tt_dat';
end