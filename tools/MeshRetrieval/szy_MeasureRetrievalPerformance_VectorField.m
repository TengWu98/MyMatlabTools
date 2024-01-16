function [NN_right, Tier1, Tier2, DCG, E_Measure, PRCurve] = szy_MeasureRetrievalPerformance_VectorField(Features_VectorField, classNumber, trainSampleIndicesForEachClass, L)
Labels = szy_GenerateLabels(classNumber);
% 训练集，仅用于构造字典
% 因为要用Bag of Feature，所以拿前5个模型作为训练集构造字典。
% 如果拿所有模型作为训练集构造字典的话，训练集过大，速度极慢，K-Means算法不收敛。
trainSamples = Features_VectorField(szy_GenerateSamplesIndex(classNumber, trainSampleIndicesForEachClass));
disp('开始计算Bag of Features...');
[~, A] = szy_BagOfFeatures(trainSamples, Features_VectorField, L);
DistanceMatrix = squareform(pdist(A', 'cityblock'));
[NN_right, Tier1, Tier2, DCG, E_Measure, PRCurve] = szy_MeasureRetrievalPerformance2(DistanceMatrix, Labels);
end