% function [ConsistencyError, HammingDistance, CutDiscrepancy, RandIndex] = ...
%     szy_GetSegmentationScore_Mean(MeshFileName, SegFileName, refSegFileDir)
function [ConsistencyError, HammingDistance, CutDiscrepancy, RandIndex] = ...
    szy_GetSegmentationScore_Mean(MeshFileName, SegFileName, refSegFileDir)

refSegFiles = dir([refSegFileDir, '*.seg']);
AllCE = [];
AllHD = [];
AllCD = [];
AllRI = [];

parfor j = 1:size(refSegFiles, 1)
    refSegFileName = [refSegFileDir, refSegFiles(j).name];
    [CE, HD, CD, RI] = szy_GetSegmentationScore_Single(MeshFileName, ...
        SegFileName, refSegFileName);
    AllCE(:, j) = CE;
    AllHD(:, j) = HD;
    AllCD(:, j) = CD;
    AllRI(:, j) = RI;
end

ConsistencyError = mean(AllCE, 2);
HammingDistance = mean(AllHD, 2);
CutDiscrepancy = mean(AllCD, 2);
RandIndex = mean(AllRI, 2);

end