function szy_PlotMesh_Discrete_vf(vertex, face, LabelOfEachFace)
% szy_PlotMesh_Discrete_vf(vertex, face, LabelOfEachFace)
% 绘制彩色网格模型，LabelOfEachFace是一个行向量或列向量，长度与模型的面片数一致，表示每个
% 面片上的标签值，从1开始，函数根据这个标签值的不同对模型的面片进行不同着色。
mesh = makeMesh(vertex', face');
% 由于readMesh只能支持.obj，所以更换为read_mesh
% mesh = readMesh(fileName, 'nC');
Colors = [ 1,0,0; 0,1,0; 0,0,1; 1,0,1; 0,1,1; 1,1,0; 
            1,.3,.7; 1,.7,.3; .7,1,.3; .3,1,.7; .7,.3,1; .3,.7,1; 
            1,.5,.5; .5,1,.5; .5,.5,1; 1,.5,1; .5,1,1; 1,1,.5; 
            .5,0,0; 0,.5,0; 0,0,.5; .5,0,.5; 0,.5,.5; .5,.5,0];
if size(LabelOfEachFace, 1) == 1
    LabelOfEachFace = LabelOfEachFace';
end
% 24种颜色循环，方便看清，思路拷贝自Princeton Segmentation Benchmark自带的程序mshView。
label = mod(LabelOfEachFace - 1, 24) + 1;
vC = Colors(label, :);
plotMesh(mesh, 'f', vC);
end