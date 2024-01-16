% AreaOfVertex = szy_GetAreaOfVertices_vf(vertex, face)
% 得到所有顶点的Voronoi面积
function AreaOfVertex = szy_GetAreaOfVertices_vf(vertex, face)
% V: 3 * n
% F: 3 * n
vertex = vertex';
face = face';

num_faces = size(face, 1);
E1=sparse(face(1:num_faces,1), 1:num_faces, ones(num_faces,1), size(vertex, 1), num_faces);
E2=sparse(face(1:num_faces,2), 1:num_faces, ones(num_faces,1), size(vertex, 1), num_faces);
E3=sparse(face(1:num_faces,3), 1:num_faces, ones(num_faces,1), size(vertex, 1), num_faces);
E = [E1 E2 E3];

angles = 0*face;
squared_edge_length = 0*face;
for i=1:3
    i1 = mod(i-1,3)+1;
    i2 = mod(i  ,3)+1;
    i3 = mod(i+1,3)+1;
    pp = vertex(face(:,i2),:) - vertex(face(:,i1),:);
    qq = vertex(face(:,i3),:) - vertex(face(:,i1),:);
    % normalize the vectors
    pp = pp ./ repmat( max(sqrt(dot(pp,pp,2)),eps), [1 3] );
    qq = qq ./ repmat( max(sqrt(dot(qq,qq,2)),eps), [1 3] );
    % compute angles
    angles(:,i1) = acos(dot(pp,qq,2)); %i1对应于该面中的第i1个顶点
    rr = vertex(face(:,i2),:) - vertex(face(:,i3),:);
    squared_edge_length(:,i1) = dot(rr, rr, 2); %与i1顶点对着的那条边
end
faces_area = zeros(num_faces,1);
for i = 1:3
    faces_area = faces_area +1/4 * (squared_edge_length(:,i).*cot(angles(:,i)));
end
AreaOfVertex = zeros(num_faces, 3);
for i=1:3
    i1 = mod(i-1,3)+1;
    i2 = mod(i  ,3)+1;
    i3 = mod(i+1,3)+1;
    faceSet1 = find(angles(:,i1)>=pi/2);
    faceSet2 = union(find(angles(:,i2)>=pi/2), find(angles(:,i3)>=pi/2));
    faceSet0 = setdiff((1:num_faces)',union(faceSet1, faceSet2));
    AreaOfVertex(faceSet0(:),i1) = AreaOfVertex(faceSet0(:),i1)+1/8 * (...
        cot(angles(faceSet0(:),i2)).*squared_edge_length(faceSet0(:),i2) + ...
        cot(angles(faceSet0(:),i3)).*squared_edge_length(faceSet0(:),i3)...
        );
    AreaOfVertex(faceSet1(:),i1) = AreaOfVertex(faceSet1(:),i1) + faces_area(faceSet1(:))  * 0.5;
    AreaOfVertex(faceSet2(:),i1) = AreaOfVertex(faceSet2(:),i1) + faces_area(faceSet2(:))  * 0.25;
end
AreaOfVertex = E(:, 1:num_faces) * AreaOfVertex(:,1) + E(:, num_faces+1:2 * num_faces) * AreaOfVertex(:,2) + E(:, 2 * num_faces+1:3 * num_faces) * AreaOfVertex(:,3);
AreaOfVertex = sum(AreaOfVertex,2);
AreaOfVertex = max(AreaOfVertex,1e-8);
AreaOfVertex = AreaOfVertex';
end

