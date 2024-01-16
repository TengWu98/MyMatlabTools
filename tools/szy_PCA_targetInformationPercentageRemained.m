function [AllSamples_lowD, k, RemainedInformationPrecentage] = ...
    szy_PCA_targetInformationPercentageRemained(AllSamples, ...
    target_RemainedInformationPrecentage)
[~,score,latent] = pca(AllSamples');
temp = 0;
total = sum(latent);
for k = 1:numel(score)
    temp = temp + latent(k);
    if temp / total > target_RemainedInformationPrecentage
        break;
    end
end
AllSamples_lowD = score(:, 1:k)';
RemainedInformationPrecentage = sum(latent(1:k))/sum(latent);
end