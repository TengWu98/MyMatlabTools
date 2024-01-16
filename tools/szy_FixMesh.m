% szy_FixMesh(meshFileName, fixedMeshFileName)
function szy_FixMesh(meshFileName, fixedMeshFileName)
[a, b, ~] = fileparts(meshFileName);
meshFileNameWithOutExt = [a, '/', b];
[~,~] = dos(['meshfix.exe "', meshFileName, '"']);
[vertex, face] = read_mesh([meshFileNameWithOutExt, '_fixed.off']);
delete([meshFileNameWithOutExt, '_fixed.off']);
if exist(fixedMeshFileName, 'file') == 2
    delete(fixedMeshFileName);
end
write_mesh(fixedMeshFileName, vertex, face);
end