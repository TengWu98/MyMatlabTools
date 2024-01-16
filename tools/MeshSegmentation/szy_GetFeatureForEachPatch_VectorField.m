function FeatureInput = szy_GetFeatureForEachPatch_VectorField(FaceFeature, weight, idx, P)
L = numel(unique(idx));
sample1.M = FaceFeature;
sample1.w = weight;
trainSamples = {sample1};
testSamples = cell(1, L);
for j = 1:L
    FacesPosition = find(idx == j);
    PatchMatrix = FaceFeature(:, FacesPosition);%一个patch中每个面片上的特征值组成的矩阵
    smallWeight = weight(FacesPosition);%一个patch中所有面片的面积组成的向量
    sample2.M = PatchMatrix;
    sample2.w = smallWeight;
    testSamples{j} = sample2;
end
% bag of features
[~, tt_dat] = szy_BagOfFeatures(trainSamples, testSamples, P);
FeatureInput = tt_dat;
end