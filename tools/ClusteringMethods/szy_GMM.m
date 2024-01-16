% ProbMatrix = szy_GMM(A, clusterNum)
% 先用Kmeans++进行聚类，得到每类的中心点，可以用来初始化GMM算法，使得GMM效果更好。
function ProbMatrix = szy_GMM(A, clusterNum)

% 先用Kmeans++进行聚类，得到每类的中心点，可以用来初始化GMM算法，使得GMM效果更好。
 
% ---可以用VL包的Kmeans算法进行聚类，获得初始中心点。
% [C, idx] = vl_kmeans(feature, clusterNum, 'Verbose', 'Initialization', 'PLUSPLUS',...
%     'MaxNumIterations', 500, 'NumRepetitions', 10);

% ---或者用Matlab自带的kmeans算法聚类，默认就是用kmeans++进行初始化的。
[~, C] = kmeans(A', clusterNum);

[MEANS, COVARIANCES, PRIORS, LL, ProbMatrix] = vl_gmm(A, ...
    clusterNum, 'verbose', 'MaxNumIterations', 500, ...
    'InitMeans', C', 'InitPriors', ones(1, clusterNum) /clusterNum, ...
    'InitCovariances', zeros(size(A, 1), clusterNum), ...
	'NumRepetitions', 10);
end