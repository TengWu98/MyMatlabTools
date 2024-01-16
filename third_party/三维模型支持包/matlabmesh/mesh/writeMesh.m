function [ ] = writeMesh( mesh, filename )
% [ ] = writeMesh( mesh, filename )
%   write out mesh in .OBJ format


fid = fopen(filename, 'w');

has_vertex_tex = ( size(mesh.u,1) == size(mesh.v,1) );
has_face_tex = ( size(mesh.u,1) == size(mesh.f,1) );
has_normal = ( size(mesh.n,1) == size(mesh.v,1) );

for i = 1:numel(mesh.vidx)
    fprintf(fid, 'v %f %f %f\n', mesh.v(i,1), mesh.v(i,2), mesh.v(i,3));
end

if has_normal
    for i = 1:numel(mesh.vidx)
        fprintf(fid, 'vn %f %f %f\n', mesh.n(i,1), mesh.n(i,2), mesh.n(i,3));
    end
end

if has_vertex_tex
    for i = 1:numel(mesh.vidx)
        fprintf(fid, 'vt %f %f\n', mesh.u(i,1), mesh.u(i,2));
    end
    %以下两行由我增加。
    fprintf(fid, 'mtllib MyColorBar.mtl\n');
    fprintf(fid, 'usemtl MyColorBar\n');
elseif has_face_tex
    for i = 1:numel(mesh.fidx)
        fprintf(fid, 'vt %f %f\n', mesh.u(i,1), mesh.u(i,2));
    end
    %以下两行由我增加。
    fprintf(fid, 'mtllib MyColorBar.mtl\n');
    fprintf(fid, 'usemtl MyColorBar\n'); 
end

for i = 1:numel(mesh.fidx)
    if has_vertex_tex & has_normal
        fprintf(fid, 'f %d/%d/%d %d/%d/%d %d/%d/%d\n', mesh.f(i,1),mesh.f(i,1),mesh.f(i,1),  mesh.f(i,2),mesh.f(i,2),mesh.f(i,2),  mesh.f(i,3),mesh.f(i,3),mesh.f(i,3)  );
    elseif has_face_tex & has_normal
        fprintf(fid, 'f %d/%d/%d %d/%d/%d %d/%d/%d\n', mesh.f(i,1),i,mesh.f(i,1),  mesh.f(i,2),i,mesh.f(i,2),  mesh.f(i,3),i,mesh.f(i,3)  );
    elseif has_normal
        fprintf(fid, 'f %d//%d %d//%d %d//%d\n', mesh.f(i,1),mesh.f(i,1),  mesh.f(i,2),mesh.f(i,2),  mesh.f(i,3),mesh.f(i,3)  );
    elseif has_vertex_tex
        fprintf(fid, 'f %d/%d %d/%d %d/%d\n', mesh.f(i,1),mesh.f(i,1),  mesh.f(i,2),mesh.f(i,2),  mesh.f(i,3),mesh.f(i,3)  );
    elseif has_face_tex
        fprintf(fid, 'f %d/%d %d/%d %d/%d\n', mesh.f(i,1),i,  mesh.f(i,2),i,  mesh.f(i,3),i  );        
    else
        fprintf(fid, 'f %d %d %d\n', mesh.f(i,1),mesh.f(i,2),mesh.f(i,3)  );
    end
end

fclose(fid);


end
