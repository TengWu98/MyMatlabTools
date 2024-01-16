function [tr_dat, tt_dat, tr_lb, tt_lb] = szy_PrepareClassificationData4(...
    AllSamples, Labels, trainingNumRatio)
% [tr_dat, tt_dat, tr_lb, tt_lb] = szy_PrepareClassificationData(AllSamples, Labels, trainingNumRatio)
% 准备用来进行分类的样本数据。
% AllSamples是一个矩阵，表示所有样本，每一列是一个样本，Labels是每个样本对应的标签构成的行向量，
% trainingNumRatio是0到1之间的数值，表示每类中拿前百分之多少作为训练样本，
% 其余作为测试样本。tr_dat和tt_dat都是矩阵，每一列是一个样本，分别表示训练样本和测试样本。
% tr_lb和tt_lb分别表示训练样本和测试样本的正确分类标签。

uniqueLabel = unique(Labels);
tr_dat = [];
tt_dat = [];
tr_lb = [];
tt_lb = [];
for i = 1:max(size(uniqueLabel))
    temp = AllSamples(:, Labels == uniqueLabel(i));
    temp2 = size(temp, 2);
    trainNum = ceil(temp2*trainingNumRatio);
    tr_dat = [tr_dat temp(:, 1:trainNum)];
    tr_lb = [tr_lb repmat(uniqueLabel(i), 1, trainNum)];
    tt_dat = [tt_dat temp(:, (trainNum + 1):end)];
    tt_lb = [tt_lb repmat(uniqueLabel(i), 1, temp2 - trainNum)];
end
end