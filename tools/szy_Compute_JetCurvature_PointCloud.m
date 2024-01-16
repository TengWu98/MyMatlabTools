% [GaussianCurvature, MeanCurvature] = szy_Compute_JetCurvature_PointCloud(vertex, k, jetDegree, mongeDegree)
% 用CGAL自带的功能估计三维模型顶点上的曲率。
% vertex是顶点矩阵，每一行代表一个点。
% k表示在周围选择多少个最近的点，一起进行拟合。
% jetDegree为1到4之间，默认值为2。 
% mongeDegree大于1，默认值为2。
function [GaussianCurvature, MeanCurvature] = szy_Compute_JetCurvature_PointCloud(vertex, k, jetDegree, mongeDegree)
% 对每一个vertex计算领域内的所有点，并形成一个矩阵，每一行代表一列点，将在每行第一个点上计算曲率
large_vertex = [];
Idx = knnsearch(vertex, vertex, 'k', k);
for i = 1:size(Idx, 1)
    line = Idx(i, :);
    line = vertex(line', :)';
    line = line(:)';
    large_vertex(i, :) = line;
end
tempFileName = ['temp', szy_GUID(), '.txt'];
dlmwrite(tempFileName, large_vertex, ' ');
fileNameOfResult = ['Result', szy_GUID(), '.txt'];

if exist('jetDegree', 'var') ~= 1
    jetDegree = 2;
end

if exist('mongeDegree', 'var') ~= 1
    mongeDegree = 2;
end

[~, ~] = dos(['szy_ComputeJetCurvaturesOnFirstPointOfPointList.exe "', tempFileName, '" "', ...
    int2str(jetDegree), '" "', int2str(mongeDegree), '" "', fileNameOfResult, '"']);
JetCurvature = dlmread(fileNameOfResult);
GaussianCurvature = JetCurvature(:, 1) .* JetCurvature(:, 2);
MeanCurvature = mean(JetCurvature, 2);

delete(tempFileName, fileNameOfResult);
end
