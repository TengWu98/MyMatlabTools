function [SIHKSMatrix_Vertex, SIHKSMatrix_Face] = szy_Compute_SIHKSMatrix_vf(vertex, face)
shape.X = vertex(1,:)';
shape.Y = vertex(2,:)';
shape.Z = vertex(3,:)';
shape.TRIV = face';

% 计算SIHKS矩阵，每个点上一个size(Omega)维的向量
K = 100;            % number of eigenfunctions
alpha = 2;          % log scalespace basis

% 		T1 = 5:0.5:16;    % time scales for HKS
T2 = 1:0.2:20;    % time scales for SI-HKS, 就是论文里的tau
%         T2 = 1:(1/16):25;
Omega = 2:20;       % frequencies for SI-HKS
%         Omega = 1:6;

% compute cotan Laplacian
[shape.W, shape.A] = mshlp_matrix(shape);
shape.A = spdiags(shape.A,0,size(shape.A,1),size(shape.A,1));

% compute eigenvectors/values
opts.maxit = 1000;
[shape.evecs,shape.evals] = eigs(shape.W,shape.A,K,'sm', opts);
shape.evals = -diag(shape.evals);

% compute descriptors
% 		shape.hks = hks(shape.evecs,shape.evals,alpha.^T1);
% 		[shape.sihks, shape.schks] = sihks(shape.evecs,shape.evals,alpha,T2,Omega);
[SIHKSMatrix_Vertex, shape.schks] = sihks(shape.evecs,shape.evals,alpha,T2,Omega);
SIHKSMatrix_Vertex = SIHKSMatrix_Vertex';

% 每个面片上的SIHKS
SIHKSMatrix_Face = [];
for j = 1:size(face, 2)
    a_face = face(:, j);
    SIHKSMatrix_Face(:, j) = mean(SIHKSMatrix_Vertex(:, a_face'), 2);
end
end