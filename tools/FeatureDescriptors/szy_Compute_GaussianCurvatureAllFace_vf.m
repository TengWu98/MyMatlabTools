function GC_Face = szy_Compute_GaussianCurvatureAllFace_vf(vertex, face)
% º∆À„«˙¬ 
options.curvature_smoothing = 10;
options.verb = 0;
[~, ~, ~, ~, ~, GC_Vertex, ~] = compute_curvature(vertex,face,options);
GC_Face = [];
for i = 1:size(face, 2)
    GC_Face(i, :) = mean(GC_Vertex(face(:, i), :), 1);
end
end
