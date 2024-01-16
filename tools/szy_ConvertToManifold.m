% 将非流形的三维模型文件nonManifoldFileName修复为流形的三维模型文件manifoldFileName。resolution表示分辨率。
% 注意，resolution所指定的面片分辨率不一定是最终的分辨率，只是表示指定的resolution越大，最终模型的分辨率也越大。
function szy_ConvertToManifold(nonManifoldFileName, manifoldFileName, resolution)

if ~exist('resolution', 'var')
    resolution = 20000;
end

[~,~,ext] = fileparts(nonManifoldFileName);
inFileName = nonManifoldFileName;

if ~isequal(ext, '.obj')
    inFileName = [szy_GUID(), '.obj'];
    szy_ConvertModelFormat(nonManifoldFileName, inFileName);
end

[~,~,ext2] = fileparts(manifoldFileName);

outFileName = manifoldFileName;
if ~isequal(ext2, '.obj')
    outFileName = [szy_GUID(), '.obj'];
end

dos(['manifold.exe "', inFileName, '" "', outFileName, '" ', int2str(resolution)]);

if ~isequal(ext2, '.obj')
    szy_ConvertModelFormat(outFileName, manifoldFileName);
end

if ~isequal(ext, '.obj')
    delete(inFileName);
end

if ~isequal(ext2, '.obj')
    delete(outFileName);
end

end