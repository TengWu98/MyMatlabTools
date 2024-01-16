function ProbMatrix = szy_NaiveBayesClassification_soft(tr_dat, tt_dat, tr_lb, distribution)
if exist('distribution', 'var') ~= 1
    distribution = 'mvmn';
end
model = fitcnb(tr_dat', tr_lb', 'Distribution', distribution);
[~, ProbMatrix, ~] = predict(model, tt_dat');
end