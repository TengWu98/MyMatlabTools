% 将第一个三维形状modelFileName1的标签seg1迁移到vertex2，face2所代表的第二个三维形状上，形成新的分割标签seg2。
% 算法原理为从vertex2和face2所代表的的模型中为每个面片计算中心点，
% 在第一个模型modelFileName1中寻找离每个中心点最近的面片，
% 把那个面片对应的标签作为第二个三维形状上的标签
function seg2 = szy_TransferSeg(modelFileName1, seg1, vertex2, face2)

centers = barycenter(vertex2', face2');
closestFaceID = szy_FindClosestFaceByPoint(modelFileName1, centers);
seg2 = seg1(closestFaceID);

end