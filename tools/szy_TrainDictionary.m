function Dictionary = szy_TrainDictionary(tr_dat, tr_lb, trainingNum)
% ÑµÁ·×Öµä
BigD = [];
for i = unique(tr_lb)
    Param.data = tr_dat(:, tr_lb == i);
    % 	Param.Edata = 0.001;
    Param.Tdata = 3;
    Param.dictsize = trainingNum;
    Param.iternum = 100;
    % Param.testdata = tt_dat;
    [D, Gamma] = ksvd(Param, 'irt');
    BigD = [BigD D];
end
Dictionary = BigD;
end