% result = szy_GenerateSamplesIndex(classNumber, Indices)
% 有一个长数组，由长短不一的子数组拼成，每个子数组的长度由classNumber这个cell数组
% （每个元素是str类型，如'20'）描述，从每个子数组中取索引为Indices的位置，并将
% 这些位置在长数组中的索引位置合在一起返回。
% 由舒振宇编写。
function result = szy_GenerateSamplesIndex(classNumber, Indices)
count = 0;
result = [];
for i = 1:size(classNumber, 2)
    result = [result (count + Indices)];
    count = count + str2double(classNumber{i});
end

end