function [vertex, face] = szy_CreatePlane(Pos, Normal, xRange, yRange)
    x1 = xRange(1);
    x2 = xRange(2);
    y1 = yRange(1);
    y2 = yRange(2);
    z1 = (Pos'* Normal - [x1, y1] * Normal(1:2)) / Normal(3);
    z2 = (Pos'* Normal - [x2, y2] * Normal(1:2)) / Normal(3);
    z3 = (Pos'* Normal - [x2, y1] * Normal(1:2)) / Normal(3);
    z4 = (Pos'* Normal - [x1, y2] * Normal(1:2)) / Normal(3);
    p1 = [x1, y1, z1]';
    p2 = [x2, y1, z3]';
    p3 = [x2, y2, z2]';
    p4 = [x1, y2, z4]';
    vertex = [p1 p2 p3 p4];
    face = [3 2 1; 4 3 1]';
end