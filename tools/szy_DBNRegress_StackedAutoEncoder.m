% 注意：所有的结果都会放缩到[0, 1]之间，不太适合做一般意义上的回归
function pred_y = szy_DBNRegress_StackedAutoEncoder(tr_dat, tr_y, tt_dat, structure, ...
    max_epoch, L2WeightRegularization, SparsityRegularization, UseGPU)

if exist('L2WeightRegularization', 'var') ~= 1
    L2WeightRegularization = 0;
end

if exist('SparsityRegularization', 'var') ~= 1
    SparsityRegularization = 0;
end

if exist('UseGPU', 'var') ~= 1
    UseGPU = false;
end

autoenc = cell(1, size(structure, 2) - 1);
feat = cell(1, size(structure, 2));
feat{1} = tr_dat;
for i = 1:(size(structure, 2) - 1)
    autoenc{i} = trainAutoencoder(feat{i}, structure(:, i+1), ...
        'MaxEpochs', max_epoch, ...
        'L2WeightRegularization', L2WeightRegularization, ...
        'SparsityRegularization', SparsityRegularization, ...
        'EncoderTransferFunction', 'logsig', ...
        'DecoderTransferFunction', 'logsig', ...
        'UseGPU', UseGPU);
    feat{i+1} = encode(autoenc{i}, feat{i});
end

deepnet = autoenc{end};
for i = (size(structure, 2) - 2):-1:1
    deepnet = stack(autoenc{i}, deepnet);
end

if UseGPU
    deepnet = train(deepnet, tr_dat, tr_y, 'UseGPU', 'yes');
else
    deepnet = train(deepnet, tr_dat, tr_y, 'UseGPU', 'no');
end
pred_y = deepnet(tt_dat);
end