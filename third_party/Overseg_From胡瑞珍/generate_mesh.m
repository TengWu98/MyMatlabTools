function [model] = generate_mesh(vertex_pos, face_vids)
% Given vertex positions and triangle vertex indices,
% compute face normal, face area, face center and vertex normal
model.vertex_pos = vertex_pos;
model.face_vids = face_vids;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% face centers
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
v1_pos = vertex_pos(:, face_vids(1,:));
v2_pos = vertex_pos(:, face_vids(2,:));
v3_pos = vertex_pos(:, face_vids(3,:));
model.face_centers = (v1_pos + v2_pos + v3_pos)/3;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% face normal
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
e1_vec = v1_pos - v2_pos;
e2_vec = v3_pos - v2_pos;
e3_vec = v1_pos - v3_pos;

% crossproduct(v2, v1)
model.face_nor(1, :) = e2_vec(2, :).*e1_vec(3, :)...
    - e2_vec(3, :).*e1_vec(2, :);
model.face_nor(2, :) = e2_vec(3, :).*e1_vec(1, :)...
    - e2_vec(1, :).*e1_vec(3, :);
model.face_nor(3, :) = e2_vec(1, :).*e1_vec(2, :)...
    - e2_vec(2, :).*e1_vec(1, :);

len = sqrt(sum(model.face_nor.*model.face_nor));
model.face_nor = model.face_nor./kron(ones(3, 1), len);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% face weight
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
a2 = sum(e1_vec.*e1_vec);
b2 = sum(e2_vec.*e2_vec);
c2 = sum(e3_vec.*e3_vec);
model.face_weights = sqrt(2*(a2.*b2+a2.*c2+b2.*c2)...
    - a2.*a2 - b2.*b2 - c2.*c2)/4;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% vertex normal
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
num_faces = size(face_vids, 2);
rows = kron(1:num_faces, ones(1,3));
cols = reshape(face_vids, [1, 3*num_faces]);
vals = kron(model.face_weights, ones(1, 3));
L = sparse(rows, cols, vals);
model.vertex_nor = model.face_nor*L;
len = sqrt(sum(model.vertex_nor.*model.vertex_nor));
model.vertex_nor = model.vertex_nor./kron(ones(3,1), len);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% face topology
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
model.edge_fids = computefacetop(uint32(model.face_vids-1));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% edge vertex indices
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
left_vids = face_vids(:, model.edge_fids(1, :));
right_vids = face_vids(:, model.edge_fids(2, :));
model.edge_vids = zeros(2, size(model.edge_fids, 2));
offset = zeros(1, size(left_vids, 2));
for i = 1:3
    for j = 1:3
        subset = find(left_vids(i, :) == right_vids(j, :));
        model.edge_vids(2*subset-1 + offset(subset)) = left_vids(i,subset);
        offset(subset) = offset(subset) + 1;
    end
end