function [SuccessRatioEachClass, successRatio] = szy_GetSuccessRatio(pred_lb, tt_lb)
% [SuccessRatioEachClass, successRatio] = szy_GetSuccessRatio(pred_lb, tt_lb)
% pred_lb和tt_lb都是一个行向量，分别表示预测类别和实际类别。
% SuccessRatioEachClass是各类别的分类平均准确率，successRatio表示返回的总平均预测成功率。
% 由舒振宇编写。
successRatio = sum(pred_lb == tt_lb) / length(pred_lb);
disp(['success ratio is ', num2str(successRatio)]);

temp = unique(tt_lb);
SuccessRatioEachClass = [];
for i = 1:size(temp, 2)
    temp2 = (tt_lb == temp(i));
    SuccessRatioEachClass(i) = sum(pred_lb(temp2) == tt_lb(temp2)) / length(pred_lb(temp2));
end
end