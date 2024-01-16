function fff( labels, filename)
    fid=fopen(filename, 'w');
    [row, col] = size(labels);
    for i = 1:row
        fprintf(fid,'%d\r\n',labels(i,1));
    end
    fclose(fid);
end
