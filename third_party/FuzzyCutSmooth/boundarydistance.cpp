/*---
function [facedepth] = boundarydistance(edge_fids, face_patchids)
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
  if (nargin != 2) {
    mexErrMsgTxt("Two input arguments required.");
  }
  if (nargout != 1) {
    mexErrMsgTxt("Incorrect number of output arguments."); 
  }
  
  int num_edges = static_cast<int> (mxGetN(input[0]));
  int num_faces = static_cast<int> (mxGetN(input[1]));
  
  const int *edge_fids = (int*)mxGetData(input[0]);
  const int *face_pids = (int*)mxGetData(input[1]);
  
  vector<int> facedepth;
  facedepth.resize(num_faces);
  if (!BoundaryDistance(edge_fids, num_edges,
          face_pids, num_faces,
          &facedepth)) {
     mexErrMsgTxt("Computation failed."); 
  }
   
  output[0] = mxCreateDoubleMatrix(1, num_faces, mxREAL);
  double *data = mxGetPr(output[0]);
  for (int i = 0; i < num_faces; ++i)
      data[i] = facedepth[i];
}


