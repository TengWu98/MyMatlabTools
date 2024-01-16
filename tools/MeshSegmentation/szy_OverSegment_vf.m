function Labels = szy_OverSegment_vf(vertex, face, numberOfPatches)
tempFileName = ['temp', szy_GUID(), '.obj'];
write_mesh(tempFileName, vertex, face);
Labels = szy_OverSegment(tempFileName, numberOfPatches);
delete(tempFileName);
end