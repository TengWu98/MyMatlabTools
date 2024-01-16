function [trainSamples, testSamples, tr_lb, tt_lb] = szy_PrepareClassificationData2(...
    AllSamples, classNum, sampleNumInClass, trainingNum)
% [trainSamples, testSamples, tr_lb, tt_lb] = szy_PrepareClassificationData2(AllSamples, classNum, sampleNumInClass, trainingNum)
% 准备用来进行分类的样本数据。注意：本函数适用于Bag Of Features模型。
% AllSamples是一个cell类型，表示所有样本，classNum表示总共有多少类，
% sampleNumInClass表示每类有多少个样本，trainingNum表示每类中拿前多少个作为训练样本，
% 其余作为测试样本。trainSamples和testSamples都是cell类型，分别表示训练样本和测试样本。
% tr_lb和tt_lb分别表示训练样本和测试样本的正确分类标签。

%每一类样本中拿出几个用来作为训练样本
% trainingNum = 10;
%每一类样本中拿出几个用来作为测试样本
testNum = sampleNumInClass - trainingNum;
tr_index = szy_RepeatIndex(1:trainingNum, sampleNumInClass, classNum);
tt_index = setdiff(1:size(AllSamples, 2), tr_index);
%所有训练样本
trainSamples = AllSamples(tr_index);
%所有测试样本
testSamples = AllSamples(tt_index);
Labels = szy_RepeatIndex(ones(1, sampleNumInClass), 1, classNum);
%训练样本的类别
tr_lb = Labels(:, tr_index);
%测试样本的正确类别
tt_lb = Labels(:, tt_index);
end