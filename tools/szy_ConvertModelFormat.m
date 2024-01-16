function szy_ConvertModelFormat(inMeshFileName, outMeshFileName)
% szy_ConvertModelFormat(inMeshFileName, outMeshFileName)
% 将三维模型inMeshFileName文件转化为outMeshFileName格式。
[vertex, face] = read_mesh(inMeshFileName);
write_mesh(outMeshFileName, vertex, face);
end
