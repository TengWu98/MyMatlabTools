% adjacentMatrixOfPatch = ComputeAdjacentMatrixOfPatch(face, idx)
% idx是每个面片属于的patch序号组成的行向量，长度和面片数量相等。
% [vertex, face] = read_mesh('e:\MyPapers\3DModelData\PrincetonSegmentationBenchmark\data\off\1.off');
% idx = szy_OverSegment_vf(vertex, face, 50);
function adjacentMatrixOfPatch = ComputeAdjacentMatrixOfPatch(face, idx)
fring = compute_face_ring(face);
adjacentMatrixOfPatch = zeros(numel(unique(idx)));
for i = 1:size(face, 2)
    for j = fring{i}
        if idx(i) ~= idx(j)
            adjacentMatrixOfPatch(idx(i), idx(j)) = 1;
            adjacentMatrixOfPatch(idx(j), idx(i)) = 1;
        end
    end
end
end