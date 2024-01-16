% 得到点云Vertex中，与QueryVertex中每一个点在Range范围内的点。
% Vertex每一列代表一个点，QueryVertex的每一列代表一个点。
% NeighborVertexIndices{i}表示与QueryVertex第i个点的邻近点序号集合(为一个行向量)。
% Distances{i}表示与QueryVertex第i个点的邻近点距离集合(为一个行向量)。
function [NeighborVertexIndices, Distances] = szy_GetNeighborVertexIndicesInRange(Vertex, QueryVertex, Range)
	NS = KDTreeSearcher(Vertex');
	[NeighborVertexIndices, Distances] = rangesearch(NS, QueryVertex', Range);
	NeighborVertexIndices = NeighborVertexIndices';
	Distances = Distances';
end