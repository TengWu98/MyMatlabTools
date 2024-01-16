function [pred_lb, pred_y, deepnet] = szy_DBNClassify(tr_dat, tr_lb, tt_dat, structure, ...
    max_epoch, L2WeightRegularization, SparsityRegularization, UseGPU)

if exist('L2WeightRegularization', 'var') ~= 1
    L2WeightRegularization = 0.001;
end

if exist('SparsityRegularization', 'var') ~= 1
    SparsityRegularization = 1;
end

if exist('UseGPU', 'var') ~= 1
    UseGPU = false;
end

train_y = dummyvar(tr_lb)';

% % ×ª»»tt_lbÎªtest_y
% test_y = [];
% for i = 1:size(tt_dat, 2)
%     test_y(tt_lb(i), i) = 1;
% end

autoenc = cell(1, size(structure, 2) - 2);
feat = cell(1, size(structure, 2) - 1);
feat{1} = tr_dat;
for i = 1:(size(structure, 2) - 2)
    autoenc{i} = trainAutoencoder(feat{i}, structure(:, i+1), ...
        'MaxEpochs', max_epoch, ...
        'L2WeightRegularization', L2WeightRegularization, ...
        'SparsityRegularization', SparsityRegularization, ...
        'EncoderTransferFunction', 'logsig', ...
        'DecoderTransferFunction', 'logsig', ...
        'UseGPU', UseGPU);
    feat{i+1} = encode(autoenc{i}, feat{i});
end

softnet = trainSoftmaxLayer(feat{end}, train_y, 'MaxEpochs', max_epoch);

deepnet = softnet;
for i = (size(structure, 2) - 2):-1:1
    deepnet = stack(autoenc{i}, deepnet);
end

if UseGPU
    deepnet = train(deepnet, tr_dat, train_y, 'UseGPU', 'yes');
else
    deepnet = train(deepnet, tr_dat, train_y, 'UseGPU', 'no');
end
pred_y = deepnet(tt_dat);
[~, pred_lb] = max(pred_y);
end