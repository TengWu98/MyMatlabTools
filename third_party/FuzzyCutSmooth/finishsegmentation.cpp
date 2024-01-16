/*---
function [patchids] = finishsegmentation(edge_fids, face_coords, init_patchids)
Input: 

Output

--*/

#include "mex.h"
#include "segmentation_refinement.h"
#include <vector>
using namespace std;

void mexFunction(
     int nargout,
     mxArray *output[],
     int nargin,
     const mxArray *input[]) {
  /* check argument */
  if (nargin != 4) {
    mexErrMsgTxt("Two input arguments required.");
  }
  if (nargout != 1) {
    mexErrMsgTxt("Incorrect number of output arguments."); 
  }
  
  int num_edges = static_cast<int> (mxGetN(input[0]));
  int num_faces = static_cast<int> (mxGetN(input[1]));
  int dimension = static_cast<int> (mxGetM(input[1]));
  
  const int *edge_fids = (int*)mxGetData(input[0]);
  const double *face_coords = (double*)mxGetData(input[1]);
  const int *patch_center_ids = (int*)mxGetData(input[2]);
  const int *init_patchids = (int*)mxGetData(input[3]);
  int num_patches = 0;
  for (int i = 0; i < num_faces; ++i) {
      if (init_patchids[i]+1 >= num_patches) 
          num_patches = init_patchids[i]+1;
  }
  
  vector<int> face_patchids;
  GeneratePatches(edge_fids, num_edges,
                  face_coords, dimension, num_faces,
                  patch_center_ids,
                  init_patchids, num_patches,
                  &face_patchids);
   
  output[0] = mxCreateDoubleMatrix(1, num_faces, mxREAL);
  double *data = mxGetPr(output[0]);
  for (int i = 0; i < num_faces; ++i)
      data[i] = face_patchids[i] + 1;
}


