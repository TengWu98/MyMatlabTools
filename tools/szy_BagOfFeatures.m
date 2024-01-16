function [tr_dat, tt_dat] = szy_BagOfFeatures(trainSamples, testSamples, L, ...
    NumRepetitions, MaxNumIterations)
% [tr_dat, tt_dat] = szy_BagOfFeatures(trainSamples, testSamples, L, NumRepetitions, MaxNumIterations)
% 使用Bag of Features得到训练样本和测试样本对应的向量集。trainSamples和testSamples
% 是cell类型，其中每个元素都是一个结构体sample，其中sample.M代表矩阵，代表一个特征向量集，
% 矩阵的每一列表示一个特征向量；sample.w是一个行向量，代表M中每个特征向量对应的权重。
% 其列数与M的列数相等。
% 算法从trainSamples中构造字典，并得到trainSamples中每个矩阵在字典下的频率表达，
% 构成矩阵tr_dat，以及testSamples中每个矩阵在字典下的频率表达，构成矩阵tt_dat。
% tr_dat和tt_dat是矩阵，分别代表得到的训练集和测试集，其中每一列代表一个训练样本或测试样本。
% L代表返回的训练集和测试集中的训练样本和测试样本的维数。
% MaxNumIterations表示聚类时的最大迭代次数，默认为100000。
% NumRepetitions表示重启聚类算法的次数，默认为30。

% 多数情况下，返回的tr_dat没啥用，因为trainSamples只是用来构造字典，返回的tt_dat
% 是真正有作用的。

% 由舒振宇编写。

if exist('MaxNumIterations', 'var') ~= 1
    MaxNumIterations = 100000;
end

if exist('NumRepetitions', 'var') ~= 1
    NumRepetitions = 30;
end

disp('Constructing vocabulary...');
BigMatrix = [];
for i = 1:length(trainSamples)
    trainSample = trainSamples{i};
    BigMatrix = [BigMatrix trainSample.M];
end

disp('Clustering...');
tic
[Dict, ~] = vl_kmeans(BigMatrix, L, 'Verbose', 'Initialization', 'PLUSPLUS',...
    'MaxNumIterations', MaxNumIterations, 'NumRepetitions', NumRepetitions);
Dict = Dict';
% opts = statset('MaxIter', 1000);
% [~, Dict] = kmeans(BigMatrix', L, 'Options', opts);
toc

disp('Computing tr_dat...');
tr_dat = [];

for i = 1:length(trainSamples)
    trainSample = trainSamples{i};
    IDX = knnsearch(Dict, trainSample.M');
    
    n = zeros(L, 1);
    for k = 1:L
        n(k, 1) = sum(trainSample.w(IDX == k));
    end
    if sum(n) == 0
        error('BagOfFeature出现错误，特征向量中出现全0向量，说明模型中有0面积的面片！');
    end    
    d = n / sum(n);
    tr_dat(:, i) = d;
end

disp('Computing tt_dat...');
tt_dat = [];

for i = 1:length(testSamples)
    testSample = testSamples{i};
    IDX = knnsearch(Dict, testSample.M');

    n = zeros(L, 1);
    for k = 1:L
        n(k, 1) = sum(testSample.w(IDX == k));
    end
    if sum(n) == 0
        error('BagOfFeature出现错误，特征向量中出现全0向量，说明模型中有0面积的面片！');
    end    

    d = n / sum(n);
    
    tt_dat(:, i) = d;
end

if sum(sum(isnan(tr_dat))) ~= 0
    error('tr_dat包含NaN，错误！');
end
if sum(sum(isnan(tt_dat))) ~= 0
    error('tt_dat包含NaN，错误！');
end

if sum(sum(isinf(tr_dat))) ~= 0
    error('tr_dat包含inf，错误！');
end
if sum(sum(isinf(tt_dat))) ~= 0
    error('tt_dat包含inf，错误！');
end
end