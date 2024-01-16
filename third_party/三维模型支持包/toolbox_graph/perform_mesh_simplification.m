function [vertex,face] = perform_mesh_simplification(vertex,face,nface,fileID)

% perform_mesh_simplification - simplify a 3D mesh
%
%   [vertex,face] = perform_mesh_simplification(vertex,face,nface);
%   其中fileID是一个全局唯一的字符串，用于并行时防止出现写入同一临时文件的冲突
%   This is a simple wrapper to QSlim command line software
%       http://graphics.cs.uiuc.edu/~garland/software/qslim.html
%   The methode is based on the following paper
%       Michael Garland and Paul Heckbert, 
%       Surface Simplification Using Quadric Error Metrics, 
%       SIGGRAPH 97
%
%   Copyright (c) 2006 Gabriel Peyr?

if nargin<3
    error('Usage: [vertex,face] = perform_mesh_simplification(vertex,face,nface).');
end

% write input in smf format
write_smf(['tmp.',fileID,'.smf'], vertex, face);

% perform simplication
system(['QSlim tmp.', fileID, '.smf -o tmp.', fileID, '.1.smf -q -t ' num2str(nface)]);

% read back result
[vertex,face] = read_mesh(['tmp.', fileID, '.1.smf']);

% delete temporary files
delete(['tmp.', fileID,'.smf']);
delete(['tmp.', fileID, '.1.smf']);

% QSlim Options: 
% -------------- 
% -o <file>	Output final model to given file. 
% -s <count>	Set the target number of faces. 
% -e <thresh>	Set the maximum error tolerance. 
% -t <t>		Set pair selection tolerance. 
% -Q[pv]		Select what constraint quadrics to use [default=p]. 
% -On		Optimal placement policy. 
% 			0=endpoints, 1=endormid, 2=line, 3=optimal [default] 
% -B <weight>	Use boundary preservation planes with given weight. 
% -m		Preserve mesh quality. 
% -a		Enable area weighting. 