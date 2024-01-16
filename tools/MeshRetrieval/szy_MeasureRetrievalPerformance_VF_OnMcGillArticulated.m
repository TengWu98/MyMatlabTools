function [NN_right, Tier1, Tier2, DCG, E_Measure, PRCurve] = szy_MeasureRetrievalPerformance_VF_OnMcGillArticulated(Features_VectorField, trainSampleIndicesForEachClass, L)
dataFileDir = 'e:\MyPapers\3DModelData\McGill_articulated\';
classNumberFile = [dataFileDir, 'classNumber.txt'];
classNumber = textread(classNumberFile, '%s')';

[NN_right, Tier1, Tier2, DCG, E_Measure, PRCurve] = szy_MeasureRetrievalPerformance_VectorField(Features_VectorField, classNumber, trainSampleIndicesForEachClass, L);
end