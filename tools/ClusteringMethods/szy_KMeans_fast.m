% 利用vl_kmeans进行快速KMeans聚类，我包了一层。
function Labels = szy_KMeans_fast(A, clusterNum)
[~, Labels] = vl_kmeans(A, clusterNum, 'Verbose', 'Initialization', 'PLUSPLUS',...
    'MaxNumIterations', 500, 'NumRepetitions', 10);
end