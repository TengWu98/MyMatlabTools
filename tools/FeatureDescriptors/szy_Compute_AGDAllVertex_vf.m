function AGD = szy_Compute_AGDAllVertex_vf(vertex, face)

GD = szy_GetGeodesicDistanceMatrix_dijkstra_vf(vertex, face);
% º∆À„AGD
voronoiArea = szy_GetAreaOfVertices_vf(vertex, face);
%         agd = sum(GD, 2);
AGD = GD * voronoiArea' / sum(voronoiArea);
AGD = (AGD - min(AGD)) / max(AGD);
AGD = AGD';
end
