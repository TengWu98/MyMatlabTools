% SDF_Face = szy_Compute_SDF_AllFace(fileNameOfModel)
% isPostProcessing：true或false，表示是否用CGAL自带的后置处理功能进行处理。默认值是true。
function SDF_Face = szy_Compute_SDF_AllFace(fileNameOfModel, isPostProcessing)
[vertex, face] = read_mesh(fileNameOfModel);
tempFileName = ['temp', szy_GUID(), '.off'];
write_mesh(tempFileName, vertex, face);
fileNameOfResult = ['Result', szy_GUID(), '.txt'];

if exist('isPostProcessing', 'var') ~= 1
    isPostProcessing = true;
end

if isPostProcessing 
    isProProcessing_ = '1';
else
    isProProcessing_ = '0';
end

[~,~] = dos(['szy_ComputeSDF.exe "', tempFileName, '" "', ...
    fileNameOfResult, '" ', isProProcessing_]);
SDF_Face = dlmread(fileNameOfResult);
delete(fileNameOfResult, tempFileName);
end
