#ifndef hierarchical_clustering_h_
#define hierarchical_clustering_h_
#include <vector>
using namespace std;

struct CutCost {
 public:
  inline CutCost() {
  }
  ~CutCost() {
  }
  const	inline bool operator < (const CutCost& cc) const {
    if (ncut_cost > cc.ncut_cost) {
      return false;
    } else if (ncut_cost < cc.ncut_cost) {
      return true;
    } else {
      if (seg1_id < cc.seg1_id)
        return true;
      else if (seg1_id > cc.seg1_id)
        return false;
      else
        return seg2_id < cc.seg2_id;
    }
  }
  int seg1_id;
  int seg2_id;
  double ncut_cost;
};

struct SegmentEdge {
 public:
  SegmentEdge() {
    target_segment_id = 0;
  }
  ~SegmentEdge() {
  }
  int target_segment_id;
  double cut_cost;
};

struct GraphSegment {
 public:
  GraphSegment() {
    seg_area = 0.0;
    is_active = false;
  }
  ~GraphSegment() {
  }
  vector<int> vertex_ids;
  vector<SegmentEdge> segment_edges;
  double seg_area;
  bool is_active;
};

class HierarchicalClustering {
 public:
  HierarchicalClustering() {
  }
  ~HierarchicalClustering() {
  }
  void Compute(const vector<int> &sv_ids,
    const vector<int> &tv_ids,
    const vector<double> &edge_weights,
    const vector<double> &vertex_area,
    const int &num_segments,
    const double &area_ratio,
    vector<int> *face_segmentids);
};

#endif