function szy_PlotPatchIndexOnMesh(vertex, face, label)
% function szy_ShowPatchIndexOnMesh(vertex, face, label)
vertex_normal = compute_normal(vertex, face);
face_normal = szy_VertexValueToFaceValue(face, vertex_normal);
uniqueLabel = unique(label);
for i = 1:numel(uniqueLabel)
    temp = uniqueLabel(i);
    temp2 = find(label == temp);
    faceIndex = temp2(ceil(numel(temp2) / 2));
    faceCenter = mean(vertex(:, face(:, faceIndex)), 2);
    textPosition = faceCenter + 0.03*face_normal(:, faceIndex);
    text(textPosition(1), textPosition(2), textPosition(3), num2str(temp));
end
end