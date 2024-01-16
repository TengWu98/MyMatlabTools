#include "hierarchical_clustering.h"
#include <set>
#include <queue>
#include <cmath>

void HierarchicalClustering::Compute(
  const vector<int> &sv_ids,
  const vector<int> &tv_ids,
  const vector<double> &edge_weights,
  const vector<double> &vertex_area,
  const int &num_segments,
  const double &area_ratio,
  vector<int> *vertex_segmentids) { // 结果存在vertex_segmentids中
  int num_vertices = static_cast<int> (vertex_area.size()); // 网格的结点数
  vector<GraphSegment> segments; // 存储中间结果，共要迭代num_vertices - num_segments次
  segments.resize(2*num_vertices - num_segments); // 后面的num_vertices - num_segments位置存储中间过程
  for (int seg_id = 0; seg_id < num_vertices; ++seg_id) { // 将graph中的信息存入segments，初始每个结点都是一个class
    segments[seg_id].is_active = true;
    segments[seg_id].seg_area = vertex_area[seg_id];
    segments[seg_id].vertex_ids.push_back(seg_id);
  }

  priority_queue<CutCost> sorted_edges; // 将每两个class的边按照cutcost存入priority_queue

  // 遍历graph的每一条边，在segment中记录对应边的cutcost，即这条边的权重 
  for (int edge_id = 0; edge_id < static_cast<int> (sv_ids.size()); ++edge_id) {
    int sv_id = sv_ids[edge_id];
    SegmentEdge se;
    se.target_segment_id = tv_ids[edge_id];
    se.cut_cost = edge_weights[edge_id];
    segments[sv_id].segment_edges.push_back(se);
    if (sv_ids[edge_id] < tv_ids[edge_id]) { // 将初始graph的每条边的cutcost存入sorted_edge
      CutCost cc;                       // 其中cost为这条边的权重分别除以两个结点的面积的加和
      cc.seg1_id = sv_id;               // 选择的合并的对象不仅与边的权重有关，还与结点面积有关
      cc.seg2_id = tv_ids[edge_id];     // 若结点面积较大，cost应该较小
      cc.ncut_cost = edge_weights[edge_id]/pow(vertex_area[cc.seg1_id], area_ratio)
      + edge_weights[edge_id]/pow(vertex_area[cc.seg2_id], area_ratio);
      sorted_edges.push(cc);
    }
  }
  
  // 迭代num_vertices - num_segments次，即初始有num_vertices个class，要求最后剩num_segments个
  // class，每次迭代合并掉一个class
  for (int iter  = 0; iter < num_vertices - num_segments; ++iter) {
    CutCost top_se; // 选出sorted_edge中cost最小的edge，且满足两个结点都是active的
    do {            // 将两个结点至少有一个已经是inactive的cost较小的边全从sorted_edge中pop出
      top_se = sorted_edges.top(); // 标记为inactive的结点说明已经合并到其他node中了
      sorted_edges.pop();
    } while (!segments[top_se.seg1_id].is_active
      || !segments[top_se.seg2_id].is_active);

    
    // Two old segments to be merged， 将cost最小的两个结点合并
    GraphSegment &segment1 = segments[top_se.seg1_id];
    GraphSegment &segment2 = segments[top_se.seg2_id];

    // Place to store the new segment，存储合并后的结点
    // 共要迭代num_vertices - num_segments次， 每次迭代都在segment的graph信息后加
    // 面积更新为原来的的面积和，标记为active
    int new_segment_id = num_vertices + iter; 
    GraphSegment &new_segment = segments[new_segment_id];
    new_segment.is_active = true;
    new_segment.seg_area = segment1.seg_area + segment2.seg_area;

    // vertices contained in this new segment
    // 将合并前两个class里的点全部存在性的class中
    new_segment.vertex_ids = segment1.vertex_ids;
    for (unsigned i = 0; i < segment2.vertex_ids.size(); ++i) {
      new_segment.vertex_ids.push_back(segment2.vertex_ids[i]);
    }

    // neighboring segments of this new segment
    // 更新这个新的class的相邻class信息，即合并前两个class的相邻信息叠加
    set<int> neigh_segmentids;
    for (unsigned i = 0; i < segment1.segment_edges.size(); ++i) {
      int id = segment1.segment_edges[i].target_segment_id;
      if (id != top_se.seg2_id)
        neigh_segmentids.insert(id);
    }
    for (unsigned i = 0; i < segment2.segment_edges.size(); ++i) {
      int id = segment2.segment_edges[i].target_segment_id;
      if (id != top_se.seg1_id)
        neigh_segmentids.insert(id);
    }

    // Update edges
    // 更新active的相邻class与新的class的边的权重信息
    for (set<int>::iterator iter_int = neigh_segmentids.begin();
      iter_int != neigh_segmentids.end();
      ++iter_int) {
      GraphSegment &neigh_segment = segments[*iter_int];
      vector<SegmentEdge> old_edges = neigh_segment.segment_edges; // 之前与neigh_segment相邻的class
      neigh_segment.segment_edges.clear();

      SegmentEdge new_edge; // 新建neigh_segment与new_segment间的边
      new_edge.target_segment_id = new_segment_id;
      new_edge.cut_cost = 0.0;
      for (unsigned j = 0; j < old_edges.size(); ++j) {
        if (old_edges[j].target_segment_id == top_se.seg1_id) {
          new_edge.cut_cost += old_edges[j].cut_cost;
        } else if (old_edges[j].target_segment_id == top_se.seg2_id) {
          new_edge.cut_cost += old_edges[j].cut_cost;
        } else { // 若neigh_segment原先的相邻class不是合并的两个中的一个，边保留，否则加到新的边
          neigh_segment.segment_edges.push_back(old_edges[j]);
        }
      }
      neigh_segment.segment_edges.push_back(new_edge);

      // 同样，将这条新的边加入到new_segment的segment_edges中去
      new_edge.target_segment_id = *iter_int;
      new_segment.segment_edges.push_back(new_edge);

      // Update the queue，将new_edge加入到sorted_edges中
      CutCost new_cut;
      new_cut.seg1_id = *iter_int;
      new_cut.seg2_id = new_segment_id;
      new_cut.ncut_cost = new_edge.cut_cost/pow(neigh_segment.seg_area, area_ratio)
        + new_edge.cut_cost/pow(new_segment.seg_area, area_ratio);

      sorted_edges.push(new_cut);
    }

    // Update the tide up，将已经合并的segment标记为inactive
    segment1.is_active = false;
    segment2.is_active = false;
    segment1.segment_edges.clear();
    segment1.vertex_ids.clear();
    segment2.segment_edges.clear();
    segment2.vertex_ids.clear();
  }

  // 最后的结果存储在标记为active的segment中
  vertex_segmentids->resize(num_vertices);
  int patch_id = 0;
  for (unsigned i = 0; i < segments.size(); ++i) {
    if (segments[i].is_active) {
      GraphSegment &segment = segments[i];
      for (unsigned j = 0; j < segment.vertex_ids.size(); ++j) {
        (*vertex_segmentids)[segment.vertex_ids[j]] = patch_id;
      }
      printf("patch_id = %d, patch_size = %d.\n",
        patch_id, static_cast<int> (segment.vertex_ids.size()));
      patch_id++;
    }
  }
}