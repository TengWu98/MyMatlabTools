function Result = szy_GetSegmentationScore_Mean_vf(vertex, face, SegFileName, refSegFileDir)
refSegFiles = dir([refSegFileDir, '*.seg']);
score = [];
parfor j = 1:size(refSegFiles, 1)
    refSegFileName = [refSegFileDir, refSegFiles(j).name];
    score(:, j) = szy_GetSegmentationScore_Single_vf(vertex, face, SegFileName, refSegFileName);
end
Result = mean(score, 2);
end