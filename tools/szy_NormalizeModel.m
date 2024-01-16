function szy_NormalizeModel(inMeshFileName, outMeshFileName)
% szy_NormalizeModel(inMeshFileName, outMeshFileName)
% 将modelFileName进行归一化，使得总面积为1。
[~,~] = dos(['szy_NormalizeModel.exe "', inMeshFileName, '"']);
[a, b, ~] = fileparts(inMeshFileName);
tempFileName = [a, '/', b, '_normalized.off'];
[vertex, face] = read_mesh(tempFileName);
delete(tempFileName);
write_mesh(outMeshFileName, vertex, face);
end
