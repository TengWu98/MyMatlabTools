function yesOrNo = szy_IsManifold(vertex, face)

vertex = vertex';
face = face';
num_faces = size(face, 1);
E1=sparse(face(1:num_faces,1), 1:num_faces, ones(num_faces,1), size(vertex, 1), num_faces);
E2=sparse(face(1:num_faces,2), 1:num_faces, ones(num_faces,1), size(vertex, 1), num_faces);
E3=sparse(face(1:num_faces,3), 1:num_faces, ones(num_faces,1), size(vertex, 1), num_faces);
%E = [E1 E2 E3];

test1 = E1 * E2' + E2 * E3' + E3 * E1';
test2 = E2 * E1' + E3 * E2' + E1 * E3';
yesOrNo = max(max(test1)) <= 1 && max(max(test2)) <= 1;

end

