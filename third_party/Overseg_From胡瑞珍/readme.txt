Readme:

Step 1: compile c++ codes
mex computefacetop.cpp face_topology.cpp
mex hie_clus.cpp hierarchical_clustering.cpp

Step 2: Parameters
Para.minEdgeWeight = 0.1; // minimum edge weights
Para.alphaAngle = 0.33; // Used in make the edge weights more uniformly distributed
Para.numOfTargetPatches = 40; // number of segments
Para.areaRatio = 1.0; // See [GF08] for details

model = loadfobj('1.obj');
fpIds = normalized_cut_gf08(model, Para);