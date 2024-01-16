% 读取结果，顺序4个consistency error，3个hamming distance，
% 1个cut discrepancy，1个rand index
% 注意：这里所有的路径必须用“/”,而不是“\”，原因在于原作者程序没写好。
function Result = szy_GetSegmentationScore_Single_vf(vertex, face, SegFileName, RefSegFileName)
% N = 15;
% Results = [];
%     Result= [];
%     fnMesh = MeshFileName;
%     fnSeg = SegFileName;
%     fnSegRef = RefSegFileName;
%     dirStat = ResultStoreDir;
tempFolderName = ['ResultStoreDir', szy_GUID()];
tempModelFileName = ['tempModel', szy_GUID(), '.off'];
write_mesh(tempModelFileName, vertex, face);
mkdir(tempFolderName);
[status, cmdout] = dos(['segEval.exe "', ...
    tempModelFileName, '" "', SegFileName, '" "', ...
    RefSegFileName , '" "', tempFolderName, '" -v -CD -CE -HD -RI']);
if status ~= 0
    disp('segEval打分错误!');
    return;
end
% temp = strfind(RefSegFileName, '.');
% temp2 = strfind(RefSegFileName, '/');
[~, refSegFileNameWithoutExt, ~] = fileparts(RefSegFileName);
% refSegFileNameWithoutExt = RefSegFileName((temp2(end) + 1):(temp(end)-1));
ResCE = load([tempFolderName, '/', refSegFileNameWithoutExt, '.CE']);%4 consistency error
ResHD = load([tempFolderName, '/', refSegFileNameWithoutExt, '.HD']);%3 hamming distance
ResCD = load([tempFolderName, '/', refSegFileNameWithoutExt, '.CD']);%1 cut discrepancy
ResRI = load([tempFolderName, '/', refSegFileNameWithoutExt, '.RI']);%1 rand index
Result = [ResCE ResHD ResCD ResRI]';
%     Results = [Results; Result];
rmdir(tempFolderName, 's');
delete(tempModelFileName);
end
