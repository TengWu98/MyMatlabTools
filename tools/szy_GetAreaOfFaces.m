% function faceArea = szy_GetAreaOfFaces(modelFileName)
% 得到所有面片的面积。
function faceArea = szy_GetAreaOfFaces(modelFileName)
% vertex: 3 * n
% face: 3 * n
[vertex, face] = read_mesh(modelFileName);
vertex = vertex';
face = face';
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
num_faces = size(face, 1);
faceArea = zeros(num_faces,1);
for i = 1:3
    faceArea = faceArea +1/4 * (squared_edge_length(:,i).*cot(angles(:,i)));
end

faceArea = faceArea';
end

