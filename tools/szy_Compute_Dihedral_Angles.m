function [DihedralAngles, Index] = szy_Compute_Dihedral_Angles(fileNameOfModel)
% [DihedralAngles, Index] = szy_Compute_Dihedral_Angles(fileNameOfModel)
% 计算fileNameOfModel模型每一条边上的二面角（[-PI，PI]），放在邻接矩阵DihedralAngles中返回，
% DihedralAngles是个稀疏矩阵，其中第i行第j列的元素表示三维模型上第i个面片和第j个面片
% 之间的二面角。内部利用OpenMesh实现，结果中得到的二面角有正有负，
% 小于0的表示凹的，大于0的表示凸的。结果取绝对值以后的表示将相邻两个面片沿公共边
% 旋转到法向一致（法向指的是三维模型中每个面片上已定好的向外法向）所需要经过的角度大小。
fileNameOfResult = ['Result', szy_GUID(), '.txt'];
[~,~] = dos(['szy_Compute_Dihedral_Angles.exe "', fileNameOfModel, '" "', fileNameOfResult, '"']);
temp = dlmread(fileNameOfResult);
Index = temp(:, [1 2]);
DihedralAngles = spconvert(temp);
delete(fileNameOfResult);
end
