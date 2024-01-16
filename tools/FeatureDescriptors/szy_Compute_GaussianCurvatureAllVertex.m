function GaussianCurvatures = szy_Compute_GaussianCurvatureAllVertex(modelFileName)
[vertex, faces] = read_mesh(modelFileName);
% ¼ÆËãÇúÂÊ
options.curvature_smoothing = 10;
options.verb = 0;
[~, ~, ~, ~, ~, GaussianCurvatures, ~] = compute_curvature(vertex,faces,options);
GaussianCurvatures = GaussianCurvatures';
end
