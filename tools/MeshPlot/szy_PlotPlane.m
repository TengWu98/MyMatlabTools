function szy_PlotPlane(p, n, xRange, yRange)
    fh = @(x,y) (p'*n - n(1, 1)*x - n(2, 1)*y)/n(3, 1);
    ezmesh(fh, xRange, yRange);
end