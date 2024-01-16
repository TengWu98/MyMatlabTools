function [NN_right, Tier1, Tier2, DCG, E_Measure, PRCurve] = szy_MeasureRetrievalPerformance_ScalarField(Features_ScalarField, classNumber, L)

min_Feature = inf;
max_Feature = -inf;
for i = 1:size(Features_ScalarField, 2)
    sample = Features_ScalarField{i};
    temp = min(sample.M);
    if min_Feature > temp
        min_Feature = temp;
    end
    temp2 = max(sample.M);
    if max_Feature < temp2
        max_Feature = temp2;
    end
end

interval_a = min_Feature;
interval_b = max_Feature;
A = [];
for i = 1:size(Features_ScalarField, 2)
    sample = Features_ScalarField{i};
    d = histcwc(sample.M, sample.w, linspace(interval_a, interval_b - ...
        (interval_b - interval_a) / L, L));
    d = d / sum(d);
    A(:, i) = d;
end
Labels = szy_GenerateLabels(classNumber);

DistanceMatrix = squareform(pdist(A', 'cityblock'));
[NN_right, Tier1, Tier2, DCG, E_Measure, PRCurve] = szy_MeasureRetrievalPerformance2(DistanceMatrix, Labels);
end