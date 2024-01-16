function [NN_right, Tier1, Tier2, DCG, E_Measure, PRCurve] = szy_MeasureRetrievalPerformance_SF_OnMcGillNonArticulated(Features_ScalarField, L)
dataFileDir = 'e:\MyPapers\3DModelData\McGill_non-articulated\';
classNumberFile = [dataFileDir, 'classNumber.txt'];
classNumber = textread(classNumberFile, '%s')';

[NN_right, Tier1, Tier2, DCG, E_Measure, PRCurve] = szy_MeasureRetrievalPerformance_ScalarField(Features_ScalarField, classNumber, L);
end