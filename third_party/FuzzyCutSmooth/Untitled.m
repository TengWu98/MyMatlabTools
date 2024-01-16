param = struct('width', 10, 'alpha_min', 0.1, 'alpha_max', 0.9, 'iter', 100, 'iter_all',...
    100, 'half_brush_width', 10, 'sigma_angle', 0.6, 'num_iterations', 100);
model = 'e:\MyPapers\已发表论文\Unsupervised 3D shape segmentation and co-segmentation via deep learning\MeshsegBenchmark-1.0\data\off\1.off';
[vertex, face] = read_mesh(model);
seg = 'e:\MyPapers\已发表论文\Unsupervised 3D shape segmentation and co-segmentation via deep learning\MeshsegBenchmark-1.0\data\seg\Benchmark\1\1_0.seg';
label = dlmread(seg);
resultLabel = smoothsingmodelfunction(vertex, face, label, param);

szy_WriteMeshWithFaceColor_Discrete(vertex, face, 'f:\1.obj', label);
szy_WriteMeshWithFaceColor_Discrete(vertex, face, 'f:\2.obj', resultLabel);