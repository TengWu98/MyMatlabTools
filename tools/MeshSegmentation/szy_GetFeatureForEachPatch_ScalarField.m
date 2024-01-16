function FeatureInput = szy_GetFeatureForEachPatch_ScalarField(FaceFeature, weight, idx, P)
L = numel(unique(idx));
FeaturePatch = cell(L);
FeatureInput = zeros(P, L);
interval_a = min(FaceFeature);
interval_b = max(FaceFeature);
for j = 1:L
    FacesPosition = find(idx == j);
    PatchMatrix = FaceFeature(:, FacesPosition);%一个patch中每个面片上的特征值组成的向量
    smallWeight = weight(FacesPosition);
    FeaturePatch{j} = PatchMatrix;
    d = histcwc(FeaturePatch{j}, smallWeight, linspace(interval_a, interval_b - ...
        (interval_b - interval_a) / P, P));
    d = d / sum(d);
    % FeatureInput是一个模型上每个Patch上的特征向量组成的矩阵
    FeatureInput(:, j) = d;
end
end