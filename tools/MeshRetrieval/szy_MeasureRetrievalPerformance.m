% [NN_right, Tier1, Tier2, DCG, E_Measure, PRCurve] = szy_MeasureRetrievalPerformance(N, M, DistanceMatrix)
% 根据距离矩阵DistanceMatrix计算检索结果的性能指标，其中N是类别数，M是每个类别的样本数
function [NN_right, Tier1, Tier2, DCG, E_Measure, PRCurve] = szy_MeasureRetrievalPerformance(N, M, DistanceMatrix)
tempDistanceMatrixFileName = ['temp', szy_GUID(), 'DistanceMatrix.txt'];
dlmwrite(tempDistanceMatrixFileName, DistanceMatrix, 'delimiter', ' ');
tempResultFileName = ['temp', szy_GUID(), 'Result.txt'];
command = ['szy_MeasureRetrievalPerformance.exe ', int2str(N), ' ',...
    int2str(M), ' ', tempDistanceMatrixFileName, ' ', tempResultFileName];
dos(command);
result = dlmread(tempResultFileName);
NN_right = result(1);
Tier1 = result(2);
Tier2 = result(3);
DCG = result(4);
E_Measure = result(5);
PRCurve = [(0.1:0.1:1)', result(6:end)];
PRCurve = [0 1; PRCurve];
delete(tempDistanceMatrixFileName, tempResultFileName);
end