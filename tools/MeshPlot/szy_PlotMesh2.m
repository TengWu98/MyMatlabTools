function szy_PlotMesh2(fileName, ValueOfEachFace)
% szy_PlotMesh2(fileName, ValueOfEachFace)
% 绘制黑白网格模型，ValueOfEachFace是一个行向量，长度与模型的面片数一致，表示每个
% 面片上某种指标的数值，函数根据这个数值大小的不同对三维模型的面片进行不同着色。
[vertex, face] = read_mesh(fileName);
if exist('ValueOfEachFace', 'var') ~= 1
    ValueOfEachFace = zeros(1, size(face, 2));
end
options.face_vertex_color = ValueOfEachFace';
plot_mesh(vertex, face, options);
end
