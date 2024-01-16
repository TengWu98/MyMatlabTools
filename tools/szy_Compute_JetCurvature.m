% [GaussianCurvature, MeanCurvature] = szy_Compute_JetCurvature(fileNameOfModel)
% 用CGAL自带的功能估计三维模型顶点上的曲率。
% jetDegree为1到4之间，默认值为2。 
% mongeDegree大于1，默认值为2。
% nRing表示几领域内的顶点参与fit曲面，默认值为0，表示自动收集足够的顶点数。
function [GaussianCurvature, MeanCurvature] = szy_Compute_JetCurvature(fileNameOfModel, jetDegree, mongeDegree, nRing)
[vertex, face] = read_mesh(fileNameOfModel);
[GaussianCurvature, MeanCurvature] = szy_Compute_JetCurvature_vf(vertex, face, jetDegree, mongeDegree, nRing);
end
