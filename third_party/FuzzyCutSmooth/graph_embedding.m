function [coords] = graph_embedding(Graph)
Graph = full(Graph);
L = diag(sum(Graph)) - Graph;
[U,V] = eig(L);
if size(U,2)<4
    coords = U(:,1:3)';
else
    coords = U(:,2:4)';
end
coords = coords*10;


