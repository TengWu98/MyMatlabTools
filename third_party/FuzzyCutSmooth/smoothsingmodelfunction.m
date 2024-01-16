function [ret] = smoothsingmodelfunction(vectex, faces, label, param)
% param = struct('width',1,'alpha_min',0.1,'alpha_max',0.9,'iter',50,'iter_all',10,'half_brush_width',1,'sigma_angle',0.6, 'num_iterations',10);
% ret = smoothsingmodelfunction(vertex, faces, labels, param); 就这样调用就行了
% 调用smoothsingmodelfunction.m 方法，参数分别是dir, model_name, labels_name, param。
% dir：模型所在文件夹目录
% model_name:模型的名字
% labels_name:labels文件夹的名字
% param是结构体，里面有8个参数：
% param.width和para.half_brush_width，用于控制可变segment指标的面片范围
% param.alpha_min和 param.alpha_max：alpha的范围，高斯牛顿法中的参数
% param.iter：高斯牛顿法中得迭代步数
% param.iter_all：进行refine_seg的次数
% param.sigma_angle：优化边界中时参数
% param.num_iterations：优化边界时的参数

    write(faces, 'tmp_faces.txt');
    write_label(label, 'tmp_label.txt');
    a = ['getNeighbor.exe ', 'tmp_label.txt ', 'tmp_faces.txt ', 'tmp_neighbour.txt'];
    system(a);
    ret = smoothsinglemodel(vectex, faces, 'tmp_label.txt', 'tmp_neighbour.txt', param);
    ret = ret';
    delete('tmp_faces.txt');
    delete('tmp_label.txt');
    delete('tmp_neighbour.txt');
end
function write( faces, filename)
    fid=fopen(filename, 'w');
    [row, col] = size(faces);
    for i = 1:col
        fprintf(fid,'%d %d %d\r\n',faces(1,i), faces(2,i), faces(3,i));
    end
    fclose(fid);
end
function write_label( labels, filename)
    fid=fopen(filename, 'w');
    [row, col] = size(labels);
    for i = 1:row
        fprintf(fid,'%d\r\n',labels(i,1));
    end
    fclose(fid);
end