function szy_PlotSkeleton(skeleton)
for i = 1:size(skeleton, 2)
    plot3(skeleton{i}(1, :), skeleton{i}(2, :), skeleton{i}(3, :));
    hold on
end
end