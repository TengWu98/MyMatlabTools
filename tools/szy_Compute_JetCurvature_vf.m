% [GaussianCurvature, MeanCurvature] = szy_Compute_JetCurvature_vf(vertex, face)
% 用CGAL自带的功能估计三维模型顶点上的曲率。
% jetDegree为1到4之间，默认值为2。 
% mongeDegree大于1，默认值为2。
% nRing表示几领域内的顶点参与fit曲面，默认值为0，表示自动收集足够的顶点数。
function [GaussianCurvature, MeanCurvature] = szy_Compute_JetCurvature_vf(vertex, face, jetDegree, mongeDegree, nRing)
tempFileName = ['temp', szy_GUID(), '.off'];
write_mesh(tempFileName, vertex, face);
fileNameOfResult = ['Result', szy_GUID(), '.txt'];

if exist('jetDegree', 'var') ~= 1
    jetDegree = 2;
end

if exist('mongeDegree', 'var') ~= 1
    mongeDegree = 2;
end

if exist('nRing', 'var') ~= 1
    nRing = 0;
end

[~,~] = dos(['szy_ComputeJetCurvatures.exe -f "', tempFileName, '" -o "', ...
    fileNameOfResult, '" -d "', int2str(jetDegree), '" -m "', int2str(mongeDegree), ... 
    '" -a "', int2str(nRing), '"']);
% result文件里面每一行共12个数，含义为：
% origin（4个数） maximal_principal_direction * scale（4个数）minimal_principal_direction * scale（4个数） k_1（1个数，大的主曲率） k_2（1个数，小的主曲率）
Result = dlmread(fileNameOfResult);
JetCurvature = Result(:, [13 14])';
GaussianCurvature = JetCurvature(1, :) .* JetCurvature(2, :);
MeanCurvature = mean(JetCurvature);

delete(tempFileName, fileNameOfResult);
end
