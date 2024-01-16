function [PointClouds, Normals] = szy_UniformSamplePointsOnMesh(meshFileName, Num)
% [PointClouds, Normals] = szy_ReSmaplePointCloudOnMesh(meshFileName, Num)
% 对fileNameOfModel网格曲面进行均匀重采样。返回采样点和其上的法向。
% PointClouds是3xNum的矩阵，每一列代表一个点。Normals是3xNum的矩阵，每一列代表一个法向。
[a, b, ~] = fileparts(meshFileName);
fileNameOfResult = [a, '/', b, szy_GUID(), '.txt'];
[~,~] = dos(['szy_ResamplePointCloudOnMesh.exe "', meshFileName, '" "', ...
    fileNameOfResult, '" ', int2str(Num)]);
PointCloudWithNormals = dlmread(fileNameOfResult);
delete(fileNameOfResult);
PointClouds = PointCloudWithNormals(:, 1:3)';
Normals = PointCloudWithNormals(:, 4:6)';
end
