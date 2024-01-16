% function Labels = szy_GenerateLabels(classNumber)
% 根据classNumber生成所有样本的标签向量Labels。classNumber是一个cell，每个元素代表每类的样本数的字符串类型，如
% classNumber = {'20', '30', '25'};
function Labels = szy_GenerateLabels(classNumber)
Labels = [];
for i = 1:max(size(classNumber))
    for j = 1:str2num(classNumber{i})
        Labels = [Labels i];
    end
end
end