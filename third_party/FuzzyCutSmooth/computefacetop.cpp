/*---
function [edge_faces] = computefacetop(face_vids)
Input: 

Output

--*/

#include "mex.h"
#include "face_topology.h"
#include <vector>
using namespace std;

void mexFunction(
     int nargout,
     mxArray *output[],
     int nargin,
     const mxArray *input[]) {
  /* check argument */
  if (nargin != 1) {
    mexErrMsgTxt("One input arguments required.");
  }
  if (nargout != 1) {
    mexErrMsgTxt("Incorrect number of output arguments."); 
  }

  int k = mxGetM(input[0]);
  if (k != 3) {
    mexErrMsgTxt("Input should be a 3xnum_faces .");
  }
  int num_faces = mxGetN(input[0]);

  int *face_vids = (int*)mxGetData(input[0]);
  vector<int> edge_fid1, edge_fid2;
  ComputeFaceTopology(face_vids, num_faces, &edge_fid1, &edge_fid2);

  int num_edges = static_cast<int> (edge_fid1.size());

  const int dims[2]={2, num_edges};
  output[0] = mxCreateNumericArray(2, dims, mxUINT32_CLASS, mxREAL);
  int *out_data = (int*)mxGetData(output[0]);
  for (int e_id = 0; e_id < num_edges; ++e_id) { 
    out_data[2*e_id] = edge_fid1[e_id]+1;
    out_data[2*e_id + 1] = edge_fid2[e_id]+1;
  }
}


