function [WKSMatrix_Vertex, WKSMatrix_Face] = szy_Compute_WKSMatrix_vf(vertex, face)

WKSMatrix_Vertex = compute_wks(vertex', face');
WKSMatrix_Vertex = WKSMatrix_Vertex';

% 每个面片上的SIHKS
WKSMatrix_Face = [];
for j = 1:size(face, 2)
    a_face = face(:, j);
    WKSMatrix_Face(:, j) = mean(WKSMatrix_Vertex(:, a_face'), 2);
end
end