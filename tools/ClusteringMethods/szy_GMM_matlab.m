% ProbMatrix = szy_GMM_matlab(A, clusterNum)
function ProbMatrix = szy_GMM_matlab(A, clusterNum)

% 先用Kmeans++进行聚类，得到每类的中心点，可以用来初始化GMM算法，使得GMM效果更好。
% 这样就已经用kmeans++进行初始化了，不用再单独运行前面的kmeans算法进行初始化了。        
options = statset('MaxIter', 5000, 'Display', 'final');
GMModel = fitgmdist(A', clusterNum, 'Options', options, ...
    'Replicates', 10, 'Start', 'plus');
ProbMatrix = posterior(GMModel, A')';

end