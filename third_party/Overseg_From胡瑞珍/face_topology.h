#ifndef face_topology_h_
#define face_topology_h_

#include <vector>
#include <algorithm>
#include <set>
using namespace std;

const unsigned int	FLAG_BIT = 256;
const unsigned int	ISBOUNDARY_BIT = 512;

struct Vertex {
 public:
  Vertex() {
    flags = 0;
    edge_id = -1;
    index = 0; 
  }
  ~Vertex() {
  }

  bool GetFlag() const {
    return (flags & FLAG_BIT) == FLAG_BIT;
  }
  void SetFlag(bool f) {
    if (f) {
      flags = flags | FLAG_BIT;
    } else {
      flags = flags & (~FLAG_BIT);
    }
  }
  bool GetIsBoundaryFlag() const {
    return (flags & ISBOUNDARY_BIT) == ISBOUNDARY_BIT;
  }
  void SetIsBoundaryFlag(bool f) {
    if (f){
      flags = flags | ISBOUNDARY_BIT;
    } else {
      flags = flags &(~ISBOUNDARY_BIT);
    }
  }

  /************************************************************************/
  /* only used in triangle mesh
  */
  /************************************************************************/
  int edge_id;

  /************************************************************************/
  /* flags
  */
  /************************************************************************/
  int flags;

  /************************************************************************/
  /* temp data                                                                     */
  /************************************************************************/
  int index;
};

struct Edge {
public:
  Edge() {
    start_vertex_id = -1;
    twin_edge_id	= -1;
    left_face_id	= -1;

    next_edge_id	= -1;
    prev_edge_id	= -1;
    flags = 0;
  }
  ~Edge() {
  }

  bool GetFlag() const{
    return (flags & FLAG_BIT) == FLAG_BIT;
  }
  void SetFlag(bool f) {
    if (f) {
      flags = flags | FLAG_BIT;
    } else {
      flags = flags & (~FLAG_BIT);
    }
  }
  bool GetIsBoundaryFlag() const {
    return (flags & ISBOUNDARY_BIT) == ISBOUNDARY_BIT;
  }
  void SetIsBoundaryFlag(bool f) {
    if (f){
      flags = flags | ISBOUNDARY_BIT;
    } else {
      flags = flags &(~ISBOUNDARY_BIT);
    }
  }
  int start_vertex_id;
  int twin_edge_id;
  int left_face_id;

  int next_edge_id;
  int prev_edge_id;

  int flags;
};

struct Face {
  Face() {
    first_edge_id = -1;
    flags = 0;
  }
  ~Face() {
  }
  int flags;
  int	first_edge_id;
};

void ComputeFaceTopology(const int *f_vids,
  const int &num_faces,
  vector<int> *edge_fid_1,
  vector<int> *edge_fid_2);

#endif