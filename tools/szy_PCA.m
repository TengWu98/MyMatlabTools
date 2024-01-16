function [AllSamples_lowD, RemainedInformationPrecentage] = szy_PCA(AllSamples, k)
[~,score,latent] = pca(AllSamples');
AllSamples_lowD = score(:, 1:k)';
RemainedInformationPrecentage = sum(latent(1:k))/sum(latent);
end