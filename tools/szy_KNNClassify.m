function pred_lb = szy_KNNClassify(tr_dat, tr_lb, tt_dat, k)
Mdl = fitcknn(tr_dat', tr_lb', 'NumNeighbors', k, 'Standardize', 1);
pred_lb = predict(Mdl, tt_dat');
pred_lb = pred_lb';
end