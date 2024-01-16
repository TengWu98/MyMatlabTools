% 这里ProbMatrix应该是真实的概率取-log以后得到的，
% 优化项中前面的权系数都应内蕴在AdjacentMatrix和ProbMatrix等参数中
% 参数AdjacentMatrix是图中所有node的邻接矩阵（无邻接关系为0），加上了权重，如：
% 0 2 1 0
% 2 0 0 0
% 1 0 0 3
% 0 0 3 0
% 参数ProbMatrix指的是每个node应该属于每一类的概率分布矩阵（每一列对应一个node），如：
% -log(0.1) -log(0.2) -log(0.3) -log(0.1)
% -log(0.3) -log(0.4) -log(0.5) -log(0.5)
% -log(0.6) -log(0.4) -log(0.2) -log(0.4)
% 参数InitLabel指每个node的初始类别号构成的行向量，可以通过ProbMatrix中的每列最大值来进行指定
% 返回值Label是每个node优化后最终的类别号
function Label = szy_AlphaExpansionGraphCut(AdjacentMatrix, ProbMatrix, InitLabel)

[I, J] = find(AdjacentMatrix ~= 0);
I_ = I(I < J);
J_ = J(I < J);
weight = AdjacentMatrix(sub2ind(size(AdjacentMatrix), I_, J_));
Edge = [I_ - 1, J_ - 1, weight];
fileNameOfEdges = ['Edge', szy_GUID(), '.txt'];
dlmwrite(fileNameOfEdges, Edge, 'delimiter', ' ');

fileNameOfInitLabel = ['InitLabel', szy_GUID(), '.txt'];
dlmwrite(fileNameOfInitLabel, InitLabel - 1, 'delimiter', ' ');

fileNameOfProbMatrix = ['ProbMatrix', szy_GUID(), '.txt'];
dlmwrite(fileNameOfProbMatrix, ProbMatrix, 'delimiter', ' ');

fileNameOfResult = ['Result', szy_GUID(), '.txt'];

[~,~] = dos(['szy_AlphaExpansionGraphCut.exe "', fileNameOfEdges, '" "', ...
    fileNameOfProbMatrix, '" "', fileNameOfInitLabel, '" ', ...
    int2str(size(AdjacentMatrix, 1)), ' ', int2str(size(ProbMatrix, 1)), ' "', ...
    fileNameOfResult, '"'], '-echo');

Label = dlmread(fileNameOfResult);
Label = (Label + 1)';

delete(fileNameOfResult, fileNameOfEdges, fileNameOfInitLabel, fileNameOfProbMatrix);
end

% "e:/MyPapers/MyMatlabToolbox/我的工具包/AlphaExpansionGraphCut/data/InEdges.txt"  
% "e:/MyPapers/MyMatlabToolbox/我的工具包/AlphaExpansionGraphCut/data/InProbMatrix.txt"  
% "e:/MyPapers/MyMatlabToolbox/我的工具包/AlphaExpansionGraphCut/data/InLabel.txt" 1280 10  
% "e:/MyPapers/MyMatlabToolbox/我的工具包/AlphaExpansionGraphCut/data/outLabel.txt"