% 谱聚类，W是距离矩阵，对称。k是聚类的目标数。
function Labels = szy_SpectralCluster_hard(W, k)
D = diag(sum(W));
L = D-W;

opt = struct('issym', true, 'isreal', true);
[V, ~] = eigs(L, D, k, 'lm', opt);

Labels = kmeans(V, k);
Labels = Labels';
end
