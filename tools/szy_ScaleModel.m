% szy_ScaleModel(inModelFileName, outModelFileName, alpha)
function szy_ScaleModel(inModelFileName, outModelFileName, alpha)
    [vertex, face] = read_mesh(inModelFileName);
    center = mean(vertex, 2);
    newVertex = alpha*vertex + (1-alpha)*repmat(center, 1, size(vertex,2));
    write_mesh(outModelFileName, newVertex, face);
end