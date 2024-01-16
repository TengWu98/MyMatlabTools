% index = szy_FindVertexIndexByCoordinate_vf(vertex, coordinate)
function index = szy_FindVertexIndexByCoordinate_vf(vertex, coordinate)
index = [];
for i = 1:size(coordinate, 2)
    temp = vertex - repmat(coordinate(:, i), 1, size(vertex, 2));
    [~, temp2] = min(sum(temp.^2));
    index = [index, temp2];
end
end
