% Labels = szy_GraphCut(fileNameOfModel, smoothing_lambda, ProbMatrix, cluster_2_segment)
% 对fileNameOfModel模型所有面片根据ProbMatrix概率矩阵进行GraphCut硬聚类，
% 这是对CGAL中功能的Matlab封装。
% smoothing_lambda一般取0.3，表示Graph Cuts硬聚类时能量最小化时光滑性约束的权重，属于[0,1]，
% 越大，分出的类越少，取0的话，最后分类结果类数和软聚类结果一样。
% ProbMatrix的行数和软聚类时的类别数一致，列数是模型的面片数。
% 返回值Labels是一个列向量，每一个元素是对应的三角面片的分类类别号。
% cluster_2_segment为true或者false。true表示希望分割结果四个椅子腿标号不一样，
% false表示希望分割结果四个椅子腿标号一样。
function Labels = szy_GraphCut(fileNameOfModel, smoothing_lambda, ProbMatrix, cluster_2_segment)
[vertex, face] = read_mesh(fileNameOfModel);
Labels = szy_GraphCut_vf(vertex, face, smoothing_lambda, ProbMatrix, cluster_2_segment);
end
