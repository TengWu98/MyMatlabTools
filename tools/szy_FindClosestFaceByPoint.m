% 在inMeshFileName表示的三维模型中，找到离queryPoints最近的顶点们，将他们的序号在Result中返回。
% 这里，queryPoints每一行表示一个查询点的几何坐标。
function Result = szy_FindClosestFaceByPoint(inMeshFileName, queryPoints)

fileNameOfQueryPoints = ['QueryPoints', szy_GUID(), '.txt'];
dlmwrite(fileNameOfQueryPoints, queryPoints, 'delimiter', ' ');

fileNameOfResult = ['Result', szy_GUID(), '.txt'];

[~,~] = dos(['szy_FindClosestFaceByPoint.exe "', inMeshFileName, '" "', ...
    fileNameOfQueryPoints, '" "', fileNameOfResult, '" ', '-echo']);

Result = dlmread(fileNameOfResult);
Result(end) = [];
Result = (Result + 1)';

delete(fileNameOfQueryPoints, fileNameOfResult);

end