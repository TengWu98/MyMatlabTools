function [Points, Normals, IndexOfSampledFaceForEachPoint] = ...
    szy_SamplePointsOnMesh(inputFileName, NumberOfPoints, IsBlueNoise)
[vertex, face] = read_mesh(inputFileName);

if IsBlueNoise
    [Points, IndexOfSampledFaceForEachPoint, ~, ~] = random_points_on_mesh(...
        vertex', face', NumberOfPoints, 'Color', 'blue', 'MaxIter', 10000);
else
    [Points, IndexOfSampledFaceForEachPoint, ~, ~] = random_points_on_mesh(...
        vertex', face', NumberOfPoints, 'Color', 'white', 'MaxIter', 10000);
end  

[~, normalf] = compute_normal(vertex, face);
Normals = normalf(:, IndexOfSampledFaceForEachPoint')';
end