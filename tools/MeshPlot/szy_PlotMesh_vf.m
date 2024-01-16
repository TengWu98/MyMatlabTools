function szy_PlotMesh_vf(vertex, face, ValueOfEachFace)
% szy_PlotMesh_vf(vertex, face, ValueOfEachFace)
% 绘制彩色网格模型，ValueOfEachFace是一个行向量或列向量，长度与模型的面片数一致，表示每个
% 面片上某种指标的数值，函数根据这个数值大小的不同对三维模型的面片进行不同着色。
options.OnlyForFastPlot = 1;
mesh = makeMesh(vertex', face', [], [], options);
% 由于readMesh只能支持.obj，所以更换为read_mesh
% mesh = readMesh(fileName, 'nC');
if exist('ValueOfEachFace', 'var') ~= 1
    ValueOfEachFace = zeros(1, size(face, 2));
end
if size(ValueOfEachFace, 1) == 1
    ValueOfEachFace = ValueOfEachFace';
end
plotMesh(mesh, 'f', ValueOfEachFace);
end