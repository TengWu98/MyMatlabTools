function [pred_lb, R] = szy_SRC_EachClass(tr_dat, tr_lb, tt_dat, lambda, rel_tol)
R = [];
uniqueLabel = unique(tr_lb);
parfor j = 1:max(size(uniqueLabel))
    [~, R1,~] = szy_SRC2(tr_dat(:, tr_lb == uniqueLabel(j)), ...
        tr_lb(tr_lb == uniqueLabel(j)), tt_dat, lambda, rel_tol);
    R(j, :) = R1;
end
[~, pred_lb] = min(R);
end
