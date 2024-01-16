% AreaOfVertex = szy_GetAreaOfVertices(modelFileName)
% 得到所有顶点上的Voronoi面积。
function AreaOfVertex = szy_GetAreaOfVertices(modelFileName)
    [vertex, face] = read_mesh(modelFileName);
    AreaOfVertex = szy_GetAreaOfVertices_vf(vertex, face);
end