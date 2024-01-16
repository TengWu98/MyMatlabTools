% NormalizedSDFs = szy_SDF_Values_Postprocessing(fileNameOfModel, SDFValues)
% 对原始SDF值进行后继处理，包括双边滤波，线性化，log normalize等。
function NormalizedSDFs = szy_SDF_Values_Postprocessing(fileNameOfModel, SDFValues)
[vertex, face] = read_mesh(fileNameOfModel);
tempFileName = ['temp', szy_GUID(), '.off'];
write_mesh(tempFileName, vertex, face);
tempFileName2 = ['temp', szy_GUID(), '.txt'];
dlmwrite(tempFileName2, SDFValues, ' ');
fileNameOfResult = ['Result', szy_GUID(), '.txt'];
[~,~] = dos(['szy_SDF_Values_Postprocessing.exe "', tempFileName, '" "',... 
    tempFileName2, '" "', fileNameOfResult, '"']);
NormalizedSDFs = dlmread(fileNameOfResult);
delete(fileNameOfResult, tempFileName, tempFileName2);
end
