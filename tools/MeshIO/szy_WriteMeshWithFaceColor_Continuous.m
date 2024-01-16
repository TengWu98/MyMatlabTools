function szy_WriteMeshWithFaceColor_Continuous(vertex, face, fileNameOfModel, ValueOfFace)
% szy_WriteMeshWithFaceColor(vertex, face, fileNameOfModel, ValueOfFace)
% 根据每个面片上的Value数值，根据色度条进行输出供渲染的obj格式三维模型。
mesh = makeMesh(vertex', face');
if size(ValueOfFace, 2) == 1
    ValueOfFace = ValueOfFace';
end
% 放缩到[0, 1)之间。
ValueOfFace = (ValueOfFace - min(ValueOfFace)) / (max(ValueOfFace) - min(ValueOfFace));
mesh.u = [ValueOfFace', zeros(size(ValueOfFace,2), 1)];
writeMesh(mesh, fileNameOfModel);
[directory, ~, ~] = fileparts(fileNameOfModel);
copyfile(which('MyColorBar.mtl'), directory);
copyfile(which('MyColorBar.png'), directory);
end
