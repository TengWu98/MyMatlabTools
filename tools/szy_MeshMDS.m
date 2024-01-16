% 将三维模型进行MDS变换，三维模型顶点数不能太多，
% 10000个的时候非常慢，结果几个小时出不来，1000个差不多，很快。
% 所以使用前最好对三维模型先简化一下。
function [newVertex, face] = szy_MeshMDS(vertex, face)
DistanceMatrix = szy_GetGeodesicDistanceMatrix_dijkstra_vf(vertex, face);
Y = mdscale(DistanceMatrix, 3);
newVertex = Y';
end
