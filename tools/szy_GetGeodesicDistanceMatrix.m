% GD = szy_GetGeodesicDistanceMatrix(modelFileName, saveMatFileName)
% 计算三维模型上两两顶点之间的测地距离，如果saveMatFileName参数存在，
% 则还将距离矩阵以GD的名字保存到文件saveMatFileName中。
function GD = szy_GetGeodesicDistanceMatrix(modelFileName, saveMatFileName)
% 		GeoTest.exe eight.obj -l
tempFileName = ['temp', szy_GUID(), '.obj'];
szy_ConvertModelFormat(modelFileName, tempFileName);
command = ['GeoTest.exe "', tempFileName, '" -l'];
dos(command);
% 		alien-1.obj.dist
GD = dlmread([tempFileName, '.dist'], ' ');
delete([tempFileName, '.dist']);
for p=1:size(GD,1)
    for q=1:p
        if GD(q,p) < 1.0e+10
            GD(p,q) = GD(q,p);
        else
            GD(q,p) = GD(p,q);
        end
    end
end
if exist('saveMatFileName', 'var') == 1
    save(saveMatFileName, 'GD');
end
end