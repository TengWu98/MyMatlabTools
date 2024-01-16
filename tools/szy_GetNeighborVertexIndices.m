% 得到点云Vertex中，与QueryVertex中每一个点几何位置最接近的NeighborCount个点。
% Vertex每一列代表一个点，QueryVertex的每一列代表一个点。
% NeighborVertexIndices第i列表示与QueryVertex第i个点的邻近点序号集合。
% Distances第i列表示与QueryVertex第i个点的邻近点距离集合。
function [NeighborVertexIndices, Distances] = szy_GetNeighborVertexIndices(Vertex, QueryVertex, NeighborCount)
	NS = KDTreeSearcher(Vertex');
	[NeighborVertexIndices, Distances] = knnsearch(NS, QueryVertex', 'k', NeighborCount);
	NeighborVertexIndices = NeighborVertexIndices';
	Distances = Distances';
end