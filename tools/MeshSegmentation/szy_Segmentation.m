% function Labels = szy_Segmentation(fileNameOfModel, FaceFeature, Smoothing_lambda, ...
%    ClusterNum, PatchNum, PatchDim)
% 将fileNameOfModel根据其所有面片上的FaceFeature特征向量进行分割，
% 分割结果以每个面片的分类标签合成的向量Labels返回。
% ClusterNum, PatchNum, PatchDim都有默认值。
% 其中FaceFeature是一个矩阵，每一列代表一个面片上的特征向量。
% Smoothing_lambda表示Graph Cut时候的权重系数, 一般情况下选择值为[0, 2]之间。
% ClusterNum表示Graph Cut时候的聚类数量，默认值为10。
% PatchNum表示Over Segment阶段Patch的个数，默认值为50。
% PatchDim表示Over Segment的时候每个Patch对应向量的维数，默认值为80。
function Labels = szy_Segmentation(fileNameOfModel, FaceFeature, Smoothing_lambda, ...
    ClusterNum, PatchNum, PatchDim)

[vertex, face] = read_mesh(fileNameOfModel);
Labels = szy_Segmentation_vf(vertex, face, FaceFeature, Smoothing_lambda, ...
    ClusterNum, PatchNum, PatchDim);

end