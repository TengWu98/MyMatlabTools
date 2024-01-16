function szy_PlotPoints(Points, ValueOfEachPoint)
% szy_PlotPoints(Points, ValueOfEachPoint)
% 绘制彩色点集，ValueOfEachPoint是一个行向量，长度与点数一致，表示每个
% 点上某种指标的数值，函数根据这个数值大小的不同对点云进行不同着色。
% 注意：代码还有问题！不能正常显示颜色区别，原因不明！
scatter3(Points(1, :)', Points(2, :)', Points(3, :)', 'filled', 'cdata', ValueOfEachPoint');
end