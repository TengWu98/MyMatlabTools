function [facePatchIds] = normalized_cut_gf08(Model, Para)

% Compute edge weights based on concavity
edgeConcavityWeights = compute_angle_weights(Model);

% Smooth the edge concavity weights
edgeConcavityWeights = power(edgeConcavityWeights, Para.alphaAngle);

% Edge weights, the smaller, the better
edgeWeights = 1 - (1- Para.minEdgeWeight)*edgeConcavityWeights;

% Perform hierachical clustering
graph = [double(Model.edge_fids); edgeWeights];
faceWeights = Model.face_weights/sum(Model.face_weights);

facePatchIds = hie_clus(graph, faceWeights,...
    [Para.numOfTargetPatches, Para.areaRatio]);

function [edgeConcavityWeights] = compute_angle_weights(Model)

vertexPos1 = Model.vertex_pos(:, Model.face_vids(1,:));
vertexPos2 = Model.vertex_pos(:, Model.face_vids(2,:));
vertexPos3 = Model.vertex_pos(:, Model.face_vids(3,:));

faceCenters = (vertexPos1 + vertexPos2 + vertexPos3)/3;

thetas = sum(Model.face_nor(:, double(Model.edge_fids(1,:)))...
    .*Model.face_nor(:, double(Model.edge_fids(2,:))));
thetas = acos(max(min(thetas, 1), -1));

edgeConcavityWeights = min(1, thetas);
edgeConcavityWeights = edgeConcavityWeights/max(edgeConcavityWeights);

%only concave edges
edges = faceCenters(:, double(Model.edge_fids(1,:)))-...
    faceCenters(:, double(Model.edge_fids(2,:)));

inner1 = -sum(edges.*Model.face_nor(:, Model.edge_fids(1,:)));
inner2 = sum(edges.*Model.face_nor(:, Model.edge_fids(2,:)));

edgeConcavityWeights(find(inner1 + inner2 < 0)) = 0;