function AGD = szy_Compute_AGD_On_PointCloud(PointCloud, k)
GD = szy_GetGeodesicDistanceMatrix_On_PointCloud(PointCloud, k);
% 计算AGD
AGD = mean(GD);
AGD = (AGD - min(AGD)) / max(AGD);
AGD = AGD';
end