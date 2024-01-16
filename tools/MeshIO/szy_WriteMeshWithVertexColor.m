function szy_WriteMeshWithVertexColor(vertex, face, fileNameOfModel, ValueOfVertex)
% szy_WriteMeshWithVertexColor(vertex, face, fileNameOfModel, ValueOfVertex)
% 根据每个顶点上的Value数值，根据色度条进行输出供渲染的obj格式三维模型。
mesh = makeMesh(vertex', face');
% 放缩到[0, 1]之间。
ValueOfVertex = (ValueOfVertex - min(ValueOfVertex)) / (max(ValueOfVertex) - min(ValueOfVertex));
mesh.u = [ValueOfVertex', zeros(size(ValueOfVertex,2), 1)];
writeMesh(mesh, fileNameOfModel);
[directory, ~, ~] = fileparts(fileNameOfModel);
copyfile(which('MyColorBar.mtl'), directory);
copyfile(which('MyColorBar.png'), directory);
end
