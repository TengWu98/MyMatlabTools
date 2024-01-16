function [tr_HighLevelFeature, tt_HighLevelFeature] = szy_DBNExtractHighLevelFeature(...
    tr_dat, tr_lb, tt_dat, structure, max_epoch, L2WeightRegularization, ...
    SparsityRegularization, UseGPU)

if exist('L2WeightRegularization', 'var') ~= 1
    L2WeightRegularization = 0;
end

if exist('SparsityRegularization', 'var') ~= 1
    SparsityRegularization = 0;
end

if exist('UseGPU', 'var') ~= 1
    UseGPU = false;
end

% ×ª»»tr_lbÎªtrain_y
train_y = [];
for i = 1:size(tr_dat, 2)
    train_y(tr_lb(i), i) = 1;
end

autoenc = cell(1, size(structure, 2) - 1);
feat = cell(1, size(structure, 2));
feat{1} = tr_dat;
for i = 1:(size(structure, 2) - 1)
    autoenc{i} = trainAutoencoder(feat{i}, structure(:, i+1), ...
        'MaxEpochs', max_epoch, ...
        'L2WeightRegularization', L2WeightRegularization, ...
        'SparsityRegularization', SparsityRegularization, 'UseGPU', UseGPU);
    feat{i+1} = encode(autoenc{i}, feat{i});
end

tr_HighLevelFeature = feat{i+1};

deepnet = autoenc{end};
for i = (size(structure, 2) - 2):-1:1
    deepnet = stack(autoenc{i}, deepnet);
end

tt_HighLevelFeature = deepnet(tt_dat);
end