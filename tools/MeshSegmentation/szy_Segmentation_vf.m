% function Labels = szy_Segmentation_vf(vertex, face, FaceFeature, Smoothing_lambda, ...
%     ClusterNum, PatchNum, PatchDim)
% 将fileNameOfModel根据其所有面片上的FaceFeature特征向量进行分割，
% 分割结果以每个面片的分类标签合成的向量Labels返回。
% ClusterNum, PatchNum, PatchDim都有默认值。
% 其中FaceFeature是一个矩阵，每一列代表一个面片上的特征向量。
% Smoothing_lambda表示Graph Cut时候的权重系数, 一般情况下选择值为[0, 2]之间。
% ClusterNum表示Graph Cut时候的聚类数量，默认值为10。
% PatchNum表示Over Segment阶段Patch的个数，默认值为50。
% PatchDim表示Over Segment的时候每个Patch对应向量的维数，默认值为80。
function Labels = szy_Segmentation_vf(vertex, face, FaceFeature, Smoothing_lambda, ...
    ClusterNum, PatchNum, PatchDim)

% over segmentation阶段patch的个数
if ~exist('PatchNum', 'var')
    PatchNum = 50;
end
% 每个patch对应向量的维数
if ~exist('PatchDim', 'var')
    PatchDim = 80;
end
% Graph Cut的聚类数量
if ~exist('ClusterNum', 'var')
    ClusterNum = 10;
end

Area = szy_GetAreaOfFaces_vf(vertex, face);
% Over Segmentation
%     disp(['VLKmeans Clustering ', int2str(kk), '.off ...']);
%     [~, idx] = vl_kmeans(FaceFeature, L, 'Verbose', 'Initialization', 'PLUSPLUS',...
%         'MaxNumIterations', 500, 'NumRepetitions', 10);
idx = szy_OverSegment_vf(vertex, face, PatchNum);
% 计算每个patch对应的特征向量
isVectorFeature = size(FaceFeature, 1) ~= 1;
if ~isVectorFeature
    FeatureInput = szy_GetFeatureForEachPatch_ScalarField(FaceFeature, Area, idx, PatchDim);
else
    FeatureInput = szy_GetFeatureForEachPatch_VectorField(FaceFeature, Area, idx, PatchDim);
end
% 分割

% 用高斯混合模型进行聚类，得到概率矩阵。
POSTERIORS_Patch = szy_GMM(FeatureInput, ClusterNum);
%     label = szy_KMeans(FeatureInput, clusterNum);
%     POSTERIORS_Patch = zeros(clusterNum, L);
%     for i = 1:numel(label)
%         POSTERIORS_Patch(label(i), i) = 1;
%     end
% 发现用Matlab自带的高斯混合模型算法要比vl包里的算法效果更好，likelihood更大，
% 分割的可视化效果也更好，但运算时间更长一些。
% 用Matlab自带的GMM算法进行聚类。
%     POSTERIORS_Patch = szy_GMM_matlab(FeatureInput, clusterNum);

POSTERIORS_Face = [];
for i = 1:ClusterNum
    for j = 1:PatchNum
        FacesPosition = find(idx == j);
        N = size(FacesPosition, 2);
        for k = 1:N
            POSTERIORS_Face(i, FacesPosition(k)) = POSTERIORS_Patch(i, j);
        end
    end
end
% 利用CGAL中的Graph Cut进行分割，并绘制结果。
Labels = szy_GraphCut_vf(vertex, face, Smoothing_lambda, POSTERIORS_Face, true);
end