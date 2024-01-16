% D2 = szy_Compute_D2(fileNameOfModel, L)
% 计算整个模型的D2特征向量。
function D2 = szy_Compute_D2_vf(vertex, face, L)
fileNameOfModel = ['temp', szy_GUID(), '.off'];
write_mesh(fileNameOfModel, vertex, face);
Num = 5000;
[PointClouds, ~] = szy_ReSamplePointCloudOnMesh(fileNameOfModel, Num);
D = pdist(PointClouds');
D2 = hist(D, L);
D2 = D2 / sum(D2);
delete(fileNameOfModel);
end
