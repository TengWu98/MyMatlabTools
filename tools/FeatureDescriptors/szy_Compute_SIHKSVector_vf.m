function SIHKSVector = szy_Compute_SIHKSVector_vf(vertex, face, Labels, L)
    [~, SIHKSMatrix] = szy_Compute_SIHKSMatrix_vf(vertex, face);
    sample1.M = SIHKSMatrix;
    Areas = szy_GetAreaOfFaces(vertex, face);%每个面片的面积矩阵
    sample1.w = Areas;%行向量
    trainSamples = {};
    trainSamples{1} = sample1;
    
    %testSamples
    testSamples = {};
    for j = 1:length(unique(Labels))
        sample2.M = SIHKSMatrix(:, Labels == j);%一个patch的特征矩阵
        sample2.w = Areas(Labels == j);%一个patch中面片的面积向量
        testSamples{j} = sample2;
    end
    %bag of features
    [~, tt_dat] = szy_BagOfFeatures(trainSamples, testSamples, L);
    SIHKSVector = tt_dat;
end