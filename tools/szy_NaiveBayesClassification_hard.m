function pred_lb = szy_NaiveBayesClassification_hard(tr_dat, tt_dat, tr_lb, distribution)
if exist('distribution', 'var') ~= 1
    distribution = 'mvmn';
end
model = fitcnb(tr_dat', tr_lb', 'Distribution', distribution);
[pred_lb, ~, ~] = predict(model, tt_dat');
pred_lb = pred_lb';
end