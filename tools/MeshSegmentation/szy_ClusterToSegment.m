function szy_ClusterToSegment(modelFileName, inSegFileName, outSegFileName)
[~, face] = read_mesh(modelFileName);
fring = compute_face_ring(face);
seg = load(inSegFileName);
seg = PreProcess(seg);
unique_seg = unique(seg);
newSegments = {};
i = 0;
for index = unique_seg'
    cluster = find(seg == index);
    
    while ~isempty(cluster)
        seeds = cluster(1);
        newSegments{end + 1} = [];
        i = i + 1;
        while ~isempty(seeds)
            seed = seeds(1);
            seeds(1) = [];
            temp = intersect(cluster, fring{seed});
            
            newSegments{i} = union(newSegments{i}, seed);
            newSegments{i} = union(newSegments{i}, temp);
            cluster = setdiff(cluster, seed);
            cluster = setdiff(cluster, fring{seed});
            
            seeds = union(seeds, temp);
        end
    end
end

newSeg = zeros(size(seg));
for i = 1:size(newSegments, 2)
    newSeg(newSegments{i}) = i - 1;
end

dlmwrite(outSegFileName, newSeg);