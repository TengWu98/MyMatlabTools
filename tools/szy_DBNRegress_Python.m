function pred_y = szy_DBNRegress_Python(tr_dat, tr_y, tt_dat, tt_y, structure, ...
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
    verbose = 2;
end

if exist('num_cv_folds', 'var') ~= 1
    num_cv_folds = 1;
end

if exist('standardize', 'var') ~= 1
    standardize = true;
end

tr_dat = tr_dat';
tr_y = tr_y';
tt_dat = tt_dat';
tt_y = tt_y';
dataFileName = [szy_GUID(), '.mat'];
save(dataFileName);
resultFileName = [szy_GUID(), '.mat'];

[~,~] = dos(['python e:/MyPapers/MyPythonToolbox/szy_dbnregress_python_used_in_matlab.py "', ...
    dataFileName, '" "', resultFileName, '"'], '-echo');

load(resultFileName);
delete(dataFileName, resultFileName);
pred_y = result';
end