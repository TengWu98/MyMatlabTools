% 利用2010年希腊人论文提供的代码，为模型modelFileName计算628维的特征向量，并存储到featureFileName中。
% 628维特征向量按顺序分别为the curvature (64维), PCA (48维), geodesic shape contexts (270维), 
% geodesic distance features (15维), shape diameter (72维), distance from medial surface (24维), 
% spin images (100维), shape context class probabilities (35维) 
function szy_ComputeMeshSegmentationFeatures(modelFileName, featureFileName)

tempFileName = ['meshes_to_compute_features_', szy_GUID(), '.txt'];
fid = fopen(tempFileName, 'w');          
if fid ~= -1
  fprintf(fid, '%s %s', modelFileName, featureFileName);
  fclose(fid);                  
end

command = ['szy_ComputeMeshSegmentationFeatures.exe 1 "', tempFileName, '"'];
dos(command);

delete(tempFileName);
end