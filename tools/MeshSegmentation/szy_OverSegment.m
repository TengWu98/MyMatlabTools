function Labels = szy_OverSegment(modelFileName, numberOfPatches)
[~, ~, fileExt] = fileparts(modelFileName);
if ~strcmp(fileExt, '.obj')
    tempFileName = ['temp', szy_GUID(), '.obj'];
    szy_ConvertModelFormat(modelFileName, tempFileName);
    model = loadfobj(tempFileName);
    delete(tempFileName);
else
    model = loadfobj(modelFileName);
end

Para.minEdgeWeight = 0.1; % minimum edge weights
Para.alphaAngle = 0.33; % Used in make the edge weights more uniformly distributed
Para.numOfTargetPatches = numberOfPatches; % number of segments
Para.areaRatio = 1.0; % See [GF08] for details

Labels = normalized_cut_gf08(model, Para);
end