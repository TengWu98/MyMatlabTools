function VectorField_Face = szy_ConvertVectorFieldFromPatchToFace(VectorField_Patch, idx)
clusterNum = size(VectorField_Patch, 1);
VectorField_Face = [];
for m = 1:clusterNum
    for j = 1:numel(unique(idx))
        FacesPosition = find(idx == j);
        for k = 1:size(FacesPosition, 2)
            VectorField_Face(m, FacesPosition(k)) = VectorField_Patch(m, j);
        end
    end
end
