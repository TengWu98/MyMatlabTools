% [NN_right, Tier1, Tier2, DCG, E_Measure, PRCurve] = szy_MeasureRetrievalPerformance3(AllSamples, Labels)
% 根据所有样本组成的矩阵AllSamples计算检索结果的性能指标，其中Labels是每个样本的标签
function [NN_right, Tier1, Tier2, DCG, E_Measure, PRCurve] = ...
    szy_MeasureRetrievalPerformance3(AllSamples, Labels)

DistanceMatrix = squareform(pdist(AllSamples', 'cityblock'));
[NN_right, Tier1, Tier2, DCG, E_Measure, PRCurve] = ...
    szy_MeasureRetrievalPerformance2(DistanceMatrix, Labels);
end