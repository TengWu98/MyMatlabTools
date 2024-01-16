function [model] = loadfobj(filename)

nv = 0;
nf = 0;
vertex_pos = zeros(3, 100000);
face_vids = zeros(3, 200000);
f_id = fopen(filename, 'r');
while 1
    tline = fgetl(f_id);
    if isempty(tline)
        continue;
    end
    if tline(1) == -1
        break;
    end
    if tline(1) == 'v' && tline(2)~='t'
        nv = nv + 1;
        vertex_pos(:, nv) = sscanf(tline, 'v %lf %lf %lf\n');
    end
    if tline(1) == 'f'
        nf = nf + 1;
        face_vids(:, nf) = sscanf(tline, 'f %d %d %d\n');
    end
end
fclose(f_id);

vertex_pos = vertex_pos(:, 1:nv);
face_vids = face_vids(:, 1:nf);

model = generate_mesh(vertex_pos, face_vids);