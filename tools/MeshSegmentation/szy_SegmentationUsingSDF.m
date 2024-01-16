function Labels = szy_SegmentationUsingSDF(fileNameOfModel, cluster_Num, ...
    smoothing_lambda)
% Labels = szy_SegmentationUsingSDF(fileNameOfModel, cluster_Num, smoothing_lambda);
% 对fileNameOfModel模型进行分割，这是对CGAL中功能的Matlab封装。
% 结合SDF指标，先用混合高斯模型进行软聚类，
% 然后用Graph Cuts进行硬聚类。 cluster_Num表示软聚类的类别目标数。
% smoothing_lambda一般取0.3，表示Graph Cuts硬聚类时能量最小化时光滑性约束的权重，属于[0,1]，
% 越大，分出的类越少，取0的话，最后分类结果类数和软聚类结果一样，等于cluster_Num。
% 返回值Labels是一个列向量，每一个元素是对应的三角面片的分类类别号。
[vertex, face] = read_mesh(fileNameOfModel);
tempFileName = ['temp', szy_GUID(), '.off'];
write_mesh(tempFileName, vertex, face);
fileNameOfResult = ['Result', szy_GUID(), '.txt'];
[~,~] = dos(['szy_SegmentationUsingSDF.exe "', tempFileName, '" "', ...
    fileNameOfResult, '" ', int2str(cluster_Num), ' ', num2str(smoothing_lambda)]);
Labels = dlmread(fileNameOfResult);
delete(fileNameOfResult, tempFileName);
end
