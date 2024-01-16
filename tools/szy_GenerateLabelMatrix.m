function Result = szy_GenerateLabelMatrix(Labels)
clusterNum = max(Labels);
Result = zeros(clusterNum, numel(Labels));
Result(sub2ind(size(Result), Labels, 1:numel(Labels))) = 1;
end