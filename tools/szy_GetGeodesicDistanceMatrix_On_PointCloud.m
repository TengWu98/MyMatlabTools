function DistanceMatrix = szy_GetGeodesicDistanceMatrix_On_PointCloud(PointCloud, k)
[Idx, D] = knnsearch(PointCloud, PointCloud, "K", k);
% weight = zeros(size(Idx, 1));
weight = sparse(size(Idx, 1), size(Idx, 1));
for i = 1:size(Idx, 1)
    for j = 1:k
        weight(i, Idx(i, j)) = D(i, j);
        weight(Idx(i, j), i) = D(i, j);
%         if weight(i, Idx(i, j)) < weight(Idx(i, j), i)
%             weight(Idx(i, j), i) = weight(i, Idx(i, j));
%         end
    end
end
G = graph(weight);
% G = sparse(weight);
DistanceMatrix = distances(G);
% DistanceMatrix = [];
% for i = 1:size(Idx,1)
%     for j = 1:size(Idx,1)
%         [dist, ~, ~] = graphshortestpath(G, i, j);
%         DistanceMatrix(i, j) = dist;
%     end
% end
end




