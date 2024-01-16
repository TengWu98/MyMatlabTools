% [X_Train, Y_Train, layers, training_options] = szy_Create_DBNRegress_Model(tr_dat, tr_y, structure, ...
% max_epoch, MiniBatchSize, IsVerbose, IsPlots, L2Regularization, learning_rate)
% 构造一个用于回归的MLP深度神经网络，tr_dat是训练样本，tr_y是对应的标签，structure是MLP神经网络的结构，
% max_epoch是迭代的最大epoch数量，batch_size是批数量，IsVerbose表示是否需要输出，IsPlots表示是否需要绘制训练过程，
% L2Regularization表示L2正则化的系数，learning_rate表示学习率。
function [X_Train, Y_Train, layers, training_options] = szy_Create_DBNRegress_Model(tr_dat, tr_y, structure, ...
    max_epoch, batch_size, IsVerbose, IsPlots, L2Regularization, learning_rate)

if exist('batch_size', 'var') ~= 1
    batch_size = 32;
end

if exist('L2Regularization', 'var') ~= 1
    L2Regularization = 0.0001;
end

if exist('learning_rate', 'var') ~= 1
    learning_rate = 0.001;
end

if exist('IsVerbose', 'var') ~= 1
    IsVerbose = true;
end

if exist('IsPlots', 'var') ~= 1
    IsPlots = true;
end

if IsPlots
    Plots = 'training-progress';
else
    Plots = 'none';
end

% 从2020b版本开始，Matlab已经支持featureInputLayers输入层了，
% 所以不再需要转换成用imageInputLayer输入层。
% X_Train = szy_Convert_tr_dat_To_X_Train_For_DeepLearning(tr_dat);
X_Train = tr_dat';

Y_Train = tr_y';

% layers = [imageInputLayer([1 structure(1) 1], 'Normalization', 'none')];
layers = [featureInputLayer(structure(1))];
for i = 2:size(structure, 2)
    layers = [layers fullyConnectedLayer(structure(i)) reluLayer()];
end
layers = [layers regressionLayer()];

training_options = trainingOptions('adam', ...
    'InitialLearnRate', learning_rate, ...
    'MaxEpochs', max_epoch, ...
    'MiniBatchSize', batch_size, ...
    'L2Regularization', L2Regularization, ... 
    'Verbose',true, ...
    'Plots', Plots);
end