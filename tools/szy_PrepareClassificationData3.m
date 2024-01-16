function [train_x, test_x, train_y, test_y] = szy_PrepareClassificationData3(...
    AllSamples, classNum, sampleNumInClass, trainingNum)
% [train_x, test_x, train_y, test_y] = szy_PrepareClassificationData3(AllSamples, classNum, sampleNumInClass, trainingNum)
% 准备用来进行分类的样本数据。注意：本函数适用于深度神经网络分类模型。
% AllSamples是一个矩阵，表示所有样本，每一列是一个样本，classNum表示总共有多少类，
% sampleNumInClass表示每类有多少个样本，trainingNum表示每类中拿前多少个作为训练样本，
% 其余作为测试样本。train_x和test_x都是矩阵，每一列是一个样本，分别表示训练样本和测试样本。
% train_y和test_y都是矩阵，分别表示训练样本和测试样本的正确分类标签，每一列代表一个样本的分类信息。
% train_y和test_y形如[1 1 1 ... 1 0 0 0 ... 0 0...0
%                     0 0 0 ... 0 1 1 1 ..1 0 0...0
%                     .............................
%                     0.. ..................1 1...1]


[train_x, test_x, tr_lb, tt_lb] = szy_PrepareClassificationData(...
    AllSamples, classNum, sampleNumInClass, trainingNum);

% 后面自编码网络和神经网络接受的格式是每行一个特征向量，所以我们要转置一下。
train_y = [];
for i = 1:size(train_x, 2)
    train_y(tr_lb(i), i) = 1;
end
test_y = [];
for i = 1:size(test_x, 2)
    test_y(tt_lb(i), i) = 1;
end

end