function [model] = loadfoff(filename)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
vertex_pos = zeros(3, 100000);
face_vids = zeros(3, 200000);
f_id = fopen(filename, 'r');
tline = fgetl(f_id);
tline = fgetl(f_id);
str = deblank(tline);
S = regexp(str, '\s+', 'split');
num_vet = str2num(cell2mat(S(1)));
num_face = str2num(cell2mat(S(2)));
num = 0;
nv = 0;
nf = 0;
while 1
    tline = fgetl(f_id);
    if isempty(tline)
        continue;
    end
    if tline(1) == -1
        break;
    end
    if num < num_vet
        nv = nv + 1;
        vertex_pos(:, nv) = sscanf(tline, '%lf %lf %lf\n');
    else
        nf = nf + 1;
        a = sscanf(tline, '%d %d %d\n');
        face_vids(:, nf) = a(2:4,:) + 1;
        
    end
    num = num + 1;
end
fclose(f_id);
vertex_pos = vertex_pos(:, 1:nv);
face_vids = face_vids(:, 1:nf);
model = generate_mesh(vertex_pos, face_vids);
end

