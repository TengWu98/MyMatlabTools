% ValueOfEachFace = szy_VertexValueToFaceValue(face, ValueOfEachVertex)
% ValueOfEachVertex为矩阵，每一列代表一个顶点上的特征向量，
% ValueOfEachFace为矩阵，每一列代表一个面片上的特征向量，
% face是read_mesh得到的face。
function ValueOfEachFace = szy_VertexValueToFaceValue(face, ValueOfEachVertex)
    ValueOfEachFace = zeros(size(ValueOfEachVertex, 1), size(face, 2));
    for i = 1:size(ValueOfEachVertex, 1)
        temp = ValueOfEachVertex(i, :);
        ValueOfEachFace(i, :) = mean(temp(face));
    end
end