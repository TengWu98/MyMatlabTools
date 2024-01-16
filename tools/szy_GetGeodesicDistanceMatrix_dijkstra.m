function DistanceMatrix = szy_GetGeodesicDistanceMatrix_dijkstra(meshFileName)
[vertex, face] = read_mesh(meshFileName);
DistanceMatrix = szy_GetGeodesicDistanceMatrix_dijkstra_vf(vertex, face);
end