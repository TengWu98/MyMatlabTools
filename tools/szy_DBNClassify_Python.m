function [pred_lb, pred_prob] = szy_DBNClassify_Python(tr_dat, tr_lb, tt_dat, tt_lb, structure, ...
    num_epoches, batch_size, verbose, num_cv_folds, standardize)

% if exist('L2WeightRegularization', 'var') ~= 1
%     L2WeightRegularization = 0;
% end
%
% if exist('SparsityRegularization', 'var') ~= 1
%     SparsityRegularization = 0;
% end

if exist('batch_size', 'var') ~= 1
    batch_size = 5;
end

if exist('verbose', 'var') ~= 1
    verbose = 0;
end

if exist('num_cv_folds', 'var') ~= 1
    num_cv_folds = 1;
end

if exist('standardize', 'var') ~= 1
    standardize = true;
end

tr_dat = tr_dat';
tt_dat = tt_dat';
tr_lb = tr_lb - 1;
tt_lb = tt_lb - 1;
dataFileName = [szy_GUID(), '.mat'];
save(dataFileName);
resultFileName = [szy_GUID(), '.mat'];

[~,~] = dos(['python e:/MyPapers/MyPythonToolbox/szy_dbnclassify_python_used_in_matlab.py "', ...
    dataFileName, '" "', resultFileName, '"'], '-echo');

load(resultFileName);
delete(dataFileName, resultFileName);
pred_prob = result';
[~, pred_lb] = max(pred_prob);
end