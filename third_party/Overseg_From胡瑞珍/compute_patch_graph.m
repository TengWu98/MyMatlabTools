%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compute the patch graph of a segmentation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [PatchGraph] = compute_patch_graph(Model, facePatchIds)

numOfPatches = max(facePatchIds);

% Boundary edges
boundaryEdgeIds = find(facePatchIds(Model.edge_fids(1,:))...
    ~=facePatchIds(Model.edge_fids(2,:)));
vertexIds1 = Model.edge_vids(1, boundaryEdgeIds);
vertexIds2 = Model.edge_vids(2, boundaryEdgeIds);

% edge centers
edgePositions = (Model.vertex_pos(:, vertexIds1)+...
    Model.vertex_pos(:, vertexIds2))/2;
edgeMoments = [edgePositions.*(ones(3,1)*edgePositions(1,:));
    edgePositions.*(ones(3,1)*edgePositions(2,:));
    edgePositions.*(ones(3,1)*edgePositions(3,:))];

edgeLength = Model.vertex_pos(:, vertexIds1)-...
    Model.vertex_pos(:, vertexIds2);
edgeLength = sqrt(sum(edgeLength.*edgeLength));

% angle between two adjacent faces
edgeAngles = sum(Model.face_nor(:, Model.edge_fids(1,:)).*...
    Model.face_nor(:, Model.edge_fids(2,:)));
edgeAngles = acos(max(min(edgeAngles, 1), -1));
dualEdges = Model.face_centers(:, Model.edge_fids(1,:))-...
    Model.face_centers(:, Model.edge_fids(2,:));
inner1 = -sum(dualEdges.*Model.face_nor(:, Model.edge_fids(1,:)));
inner2 = sum(dualEdges.*Model.face_nor(:, Model.edge_fids(2,:)));
edgeAngles(find(inner1 + inner2 < 0)) = 0;
edgeConcavityWeights = 1- sqrt(sqrt(min(1, edgeAngles)));

% compute cuts
patchIds1 = facePatchIds(Model.edge_fids(1, boundaryEdgeIds))';
patchIds2 = facePatchIds(Model.edge_fids(2, boundaryEdgeIds))';

ids = find(patchIds1 < patchIds2);
patchIds1 = patchIds1(ids);
patchIds2 = patchIds2(ids);

edgeLength = edgeLength(ids);
edgePositions = edgePositions(:, ids).*kron(ones(3,1), edgeLength);
edgeMoments = edgeMoments(:, ids).*kron(ones(9,1), edgeLength);
edgeConcavityWeights = edgeConcavityWeights(ids).*edgeLength;

PatchGraph.cuts = [kron(1:numOfPatches, ones(1, numOfPatches));
                  kron(ones(1, numOfPatches),1:numOfPatches)];
cutEdges = sparse((patchIds1-1)*numOfPatches + patchIds2,...
    1:length(ids), ones(1,length(ids)));

ids = find(sum(cutEdges') > 0);
PatchGraph.cuts = PatchGraph.cuts(:, ids);
cutEdges = cutEdges(ids, :);

PatchGraph.cutLength = (cutEdges*edgeLength')';
PatchGraph.cutCenters = (cutEdges*edgePositions')';
PatchGraph.cutMoments = (cutEdges*edgeMoments')';
PatchGraph.weightedCutLength = (cutEdges*edgeConcavityWeights')';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compute the patch graph of a segmentation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%