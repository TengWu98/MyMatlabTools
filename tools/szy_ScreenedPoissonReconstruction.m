% szy_ScreenedPoissonReconstruction(in_xyz_file_name, out_model_file_name)
% Screened Poisson重构，效果要比传统的Poisson重构好，但无法保证生成的模型一定是流形。可能还需要修复。
function szy_ScreenedPoissonReconstruction(in_xyz_file_name, out_model_file_name)
dos(['ScreenedPoissonReconstruction.exe --in "', in_xyz_file_name, '" --out "', ...
    out_model_file_name, '"']);
szy_ConvertPlyFromBinToAsc([out_model_file_name, '.ply'], [out_model_file_name, '.ply']);
szy_ConvertModelFormat([out_model_file_name, '.ply'], out_model_file_name);
delete([out_model_file_name, '.ply']);
end