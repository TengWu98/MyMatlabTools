function DistanceMatrix = szy_GetGeodesicDistanceMatrix_dijkstra_vf(vertex, face)
e = compute_edges(face);
v3 = vertex(:, e(1, :)) - vertex(:, e(2, :));
length = sqrt(sum(v3.^2));
g = graph(e(1,:), e(2, :), length);
DistanceMatrix = distances(g);
end