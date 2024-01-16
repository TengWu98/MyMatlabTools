function szy_PlotMesh(fileName, ValueOfEachFace)
% szy_PlotMesh(fileName, ValueOfEachFace)
% 绘制彩色网格模型，ValueOfEachFace是一个行向量，长度与模型的面片数一致，表示每个
% 面片上某种指标的数值，函数根据这个数值大小的不同对三维模型的面片进行不同着色。
[vertex, face] = read_mesh(fileName);
if exist('ValueOfEachFace', 'var') ~= 1
    ValueOfEachFace = zeros(1, size(face, 2));
end
mesh = makeMesh(vertex', face');
% 由于readMesh只能支持.obj，所以更换为read_mesh
% mesh = readMesh(fileName, 'nC');
plotMesh(mesh, 'f', ValueOfEachFace');
end