function pred_lb = szy_DBNClassify(tr_dat, tr_lb, tt_dat, structure, batch_size, num_epoch)

tr_dat = tr_dat';
tt_dat = tt_dat';
% 转换tr_lb为train_y
train_y = [];
for i = 1:size(tr_dat, 1)
    train_y(i, tr_lb(i)) = 1;
end

%% 200维的三维模型特征向量进来，通过一个200-100-50-30的神经网络进行预测分类，
% 其中100-50是两个中间层，30是分类的类别总数，200-100-50是Stacked Auto Encoder，
% 50-30这层用softmax分类器，类似于：
% http://deeplearning.stanford.edu/wiki/index.php/%E6%A0%88%E5%BC%8F%E8%87%AA%E7%BC%96%E7%A0%81%E7%AE%97%E6%B3%95
%

% 预训练200-100-50的Stacked Auto Encoder，内部会构造200-100-200,100-50-100的Auto Encoder进行分别训练，
% 得到局部最优的初始权重参数w。（贪婪的思想）
rng(0);
structure_1 =structure(:, 1:(end-1));
sae = saesetup(structure_1); % //其实这里nn中的W已经被随机初始化过
for i = 1:(size(structure_1, 2) - 1)
    sae.ae{i}.activation_function       = 'sigm';
    sae.ae{i}.learningRate              = 1;
    sae.ae{i}.inputZeroMaskedFraction   = 0.;
end
opts.numepochs = num_epoch;
opts.batchsize = batch_size;
sae = saetrain(sae, tr_dat, opts);% //无监督学习，不需要传入标签值，学习好的权重放在sae中，
%  //并且train_x是最后一个隐含层的输出。由于是分层预训练
%  //的，所以每次训练其实只考虑了一个隐含层，隐含层的输入有
%  //相应的denoise操作
% visualize(sae.ae{1}.W{1}(:,2:end)')

% 构造200-100-50-30的神经网络（该网络真正用来分类），
% 用前面预训练得到的自编码网络的权值w作为此神经网络的前两层200-100-50的初始权重，
% 最后一层50-30的初始权重随机取值，同时最后一层用SoftMax分类器，
% 最后输出的是输入样本属于每个不同分类的概率值，共30个，
% 取最大的那个即为预测得到的分类结果。
nn = nnsetup(structure);
nn.activation_function              = 'sigm';
nn.learningRate                     = 1;
nn.output = 'softmax';  % 指定最后一层为softmax分类器
%add pretrained weights
for i = 1:(size(structure_1, 2)-1)
    nn.W{i} = sae.ae{i}.W{1}; % 将sae训练好了的权值赋给nn网络作为初始值，覆盖了前面的随机初始化
end
% Train the FFNN
opts.numepochs = num_epoch;
opts.batchsize = batch_size;
nn = nntrain(nn, tr_dat, train_y, opts);

pred_lb = nnpredict(nn, tt_dat);
pred_lb = pred_lb';
end