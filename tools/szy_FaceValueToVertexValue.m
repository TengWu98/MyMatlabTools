% ValueOfEachVertex = szy_FaceValueToVertexValue(vertex, face, ValueOfEachFace)
% 将每个面片上的某一种向量（比如可以是特征向量）ValueOfEachFace，转化为每个顶点上的向量ValueOfEachVertex。
% ValueOfEachVertex为矩阵，每一列代表一个顶点上的特征向量，
% ValueOfEachFace为矩阵，每一列代表一个面片上的特征向量，
% vertex和face是read_mesh得到的vertex和face。
function ValueOfEachVertex = szy_FaceValueToVertexValue(vertex, face, ValueOfEachFace)
ring = compute_vertex_face_ring(face);
faceArea = szy_GetAreaOfFaces_vf(vertex, face);
weight = {};
ValueOfEachVertex = [];
for i = 1:size(vertex, 2)
    weight{i} = faceArea(ring{i});
    ValueOfEachVertex(:, i) = ValueOfEachFace(:, ring{i}) * weight{i}' / sum(weight{i});
end
end