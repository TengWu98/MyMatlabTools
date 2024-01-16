function result = PreProcess(seg)
    m = max(seg);
    a = setdiff(1:m, seg);
    a = sort(a, 'descend');
    for i = a
        seg(seg > i) = seg(seg > i) - 1;
    end
    result = seg;
end