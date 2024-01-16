function szy_PlotMesh3(fileName, ValueOfEachVertex)
% szy_PlotMesh3(fileName, ValueOfEachVertex)
% 根据点上的指标绘制彩色网格模型，ValueOfEachVertex是一个行向量，长度与模型的顶点数一致，
% 表示每个顶点上某种指标的数值，函数根据这个数值大小的不同对三维模型的面片进行不同着色。
if exist('ValueOfEachVertex', 'var') == 1
    ValueOfEachFace = szy_VertexValueToFaceValue(fileName, ValueOfEachVertex);
    szy_PlotMesh(fileName, ValueOfEachFace);
else
    szy_PlotMesh(fileName);
end
end