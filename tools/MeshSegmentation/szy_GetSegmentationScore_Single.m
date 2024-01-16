% 读取结果，顺序4个consistency error，3个hamming distance，
% 1个cut discrepancy，1个rand index
% 注意：这里所有的路径必须用“/”,而不是“\”，原因在于原作者程序没写好。
function [ConsistencyError, HammingDistance, CutDiscrepancy, RandIndex] = ...
    szy_GetSegmentationScore_Single(MeshFileName, SegFileName, RefSegFileName)
% N = 15;
% Results = [];
%     Result= [];
%     fnMesh = MeshFileName;
%     fnSeg = SegFileName;
%     fnSegRef = RefSegFileName;
%     dirStat = ResultStoreDir;
tempFolderName = ['ResultStoreDir', szy_GUID()];
mkdir(tempFolderName);
[~, ~] = dos(['segEval.exe "', ...
    MeshFileName, '" "', SegFileName, '" "', ...
    RefSegFileName , '" "', tempFolderName, '" -v -CD -CE -HD -RI']);
% temp = strfind(RefSegFileName, '.');
% temp2 = strfind(RefSegFileName, '/');
[~, refSegFileNameWithoutExt, ~] = fileparts(RefSegFileName);
% refSegFileNameWithoutExt = RefSegFileName((temp2(end) + 1):(temp(end)-1));
ConsistencyError = load([tempFolderName, '/', refSegFileNameWithoutExt, '.CE']);%4 consistency error, 这里GCE和LCE分别指的是第1个和第2个
HammingDistance = load([tempFolderName, '/', refSegFileNameWithoutExt, '.HD']);%3 hamming distance
CutDiscrepancy = load([tempFolderName, '/', refSegFileNameWithoutExt, '.CD']);%1 cut discrepancy
RandIndex = load([tempFolderName, '/', refSegFileNameWithoutExt, '.RI']);%1 rand index

ConsistencyError = ConsistencyError';
HammingDistance =HammingDistance';
CutDiscrepancy = CutDiscrepancy';
RandIndex = RandIndex';

rmdir(tempFolderName, 's');
end
