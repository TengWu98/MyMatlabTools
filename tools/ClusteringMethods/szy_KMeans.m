% KMeans聚类，feature每列一个样本，clusterNum是聚类目标数
% Labels是类别号，C是聚类中心
function [Labels, C] = szy_KMeans(feature, clusterNum)
[Labels, C] = kmeans(feature', clusterNum, 'MaxIter',10000, 'Replicates', 10,...
    'Display','final');
Labels = Labels';
end
