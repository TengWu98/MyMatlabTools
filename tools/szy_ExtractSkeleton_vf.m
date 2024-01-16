% 用CGAL中提供的功能提取三维模型的骨架skeleton，
% 以及骨架上的点和模型表面上的点之间的对应关系correspondence。
% 提取得到的skeleton可以用szy_PlotSkeleton来进行绘制。
function [skeleton, correspondence] = szy_ExtractSkeleton_vf(vertex, face)

inFileName = [szy_GUID(), '.off'];
write_mesh(inFileName, vertex, face);

fileNameOfResult1 = ['Result', szy_GUID(), '.txt'];
fileNameOfResult2 = ['Result', szy_GUID(), '.txt'];

[~,~] = dos(['szy_ExtractSkeleton.exe "', inFileName, '" "', ...
    fileNameOfResult1, '" "', fileNameOfResult2, '" '], '-echo');

skeleton = {};
i = 1;
fid = fopen(fileNameOfResult1, 'rt');
while feof(fid) ~= 1
    file = fgetl(fid);
    number = str2num(file);
    number(:, 1) = [];
    temp = reshape(number, 3, size(number, 2)/3);
    skeleton{i} = temp;
    i = i + 1;
end
fclose(fid);

correspondence = {};
i = 1;
fid = fopen(fileNameOfResult2, 'rt');
while feof(fid) ~= 1
    file = fgetl(fid);
    number = str2num(file);
    number(:, 1) = [];
    temp = reshape(number, 3, size(number, 2)/3);
    correspondence{i} = temp;
    i = i + 1;
end
fclose(fid);

delete(inFileName, fileNameOfResult1, fileNameOfResult2);
end