#include "hierarchical_clustering_new.h"
#include <set>
#include <queue>
#include <cmath>

void HierarchicalClustering::Compute(
  const vector<int> &sv_ids,
  const vector<int> &tv_ids,
  const vector<double> &edge_weights,
  const vector<bool> &active_vids,
  const vector<int> &v_patchids,  
  const int &num_segments,  // 就是patch的个数    
  vector<int> *vertex_segmentids) { // 结果存在vertex_segmentids中
  int num_vertices = static_cast<int> (active_vids.size()); // 网格的结点数
  int num_active_vertices = 0;// 网格中active的结点数
  for (int i=0; i<num_vertices;i++)
  {
	  if(active_vids[i])
	  {
		  num_active_vertices ++ ;
	  }
  }
  vector<GraphSegment> segments; // 存储中间结果，共要迭代num_active_vertices次
  segments.resize(2*num_active_vertices + num_segments); // 后面的num_active_vertices位置存储中间过程
  for (int i=0, active_id=0; i<num_vertices;i++) { // 将graph中的信息存入segments，初始每个active结点都是一个class,同属于一个patch的inactive结点是一个class
	if(active_vids[i]) // 对于active的结点，独自作为一个class
	{
		segments[active_id].is_active = true;
		segments[active_id].vertex_ids.push_back(i);
		active_id++;
	}
    else // 对于inactive的结点，所属的patch为一个class
	{
		int seg_id = v_patchids[i] + num_active_vertices - 1;
		segments[seg_id].is_active = true;
		segments[seg_id].vertex_ids.push_back(i);
	}
  }

  printf("Initial done!!!\n");
  
  priority_queue<CutCost> sorted_edges; // 将每两个class的边按照cutcost存入priority_queue
  // 初始情况下，active结点间的权重就是edge_weight，而inactive与active结点间的edge_weight就作为这个active
  // 结点与inactive结点所在patch的cutcost，两个inactive结点之间有边则必须属于同一个patch
  
  // 遍历graph的每一条边，在segment中记录对应边的cutcost，即这条边的权重 
  int num_edge = sv_ids.size();
  for (int edge_id = 0; edge_id < num_edge; ++edge_id)
  {
      int sv_id = sv_ids[edge_id];
      int tv_id = tv_ids[edge_id];
	  if(sv_id  >= num_vertices || tv_id >= num_vertices)
	  {
		  printf("sv_id or tv_id error!");
	  }
      
      // 将初始graph的每条边的cutcost存入sorted_edge
      if(active_vids[sv_id] && active_vids[tv_id])
      {
          SegmentEdge se;
          se.target_segment_id = tv_id;
          se.cut_cost = edge_weights[edge_id];
          segments[sv_id].segment_edges.push_back(se);
          
          if(sv_id < tv_id)
          {
              CutCost cc;                      
              cc.seg1_id = sv_id;              
              cc.seg2_id = tv_ids[edge_id];     
              cc.ncut_cost = edge_weights[edge_id];
              sorted_edges.push(cc);
          }          
      }
      else if (!active_vids[sv_id] && !active_vids[tv_id])
      {
          //assert(v_patchids[sv_ids[edge_id]] == v_patchids[tv_ids[edge_id]]);
          if (v_patchids[sv_id] != v_patchids[tv_id])
          {
            printf("hierarchical clustering error!!! %d  %d   %d ",edge_id, sv_ids[edge_id], tv_ids[edge_id]);
            return;
          }
      }
      else if(!active_vids[sv_id])
      {
		  if(v_patchids[sv_id] > num_segments)
		  {
			  printf("v_patchids error!!!\n");
		  }
          SegmentEdge se;
          se.target_segment_id = tv_id;
          se.cut_cost = edge_weights[edge_id];
          segments[v_patchids[sv_id] + num_active_vertices - 1].segment_edges.push_back(se);
          
          if(sv_id < tv_id)
          {
              CutCost cc;           
              cc.seg1_id = tv_id;              
              cc.seg2_id = v_patchids[sv_id] + num_active_vertices - 1;
			  cc.ncut_cost = edge_weights[edge_id];
              sorted_edges.push(cc);
          }          
      }
      else if(!active_vids[tv_id])
      {
		  if(v_patchids[tv_id] > num_segments)
		  {
			  printf("v_patchids error!!!\n");
		  }
          SegmentEdge se;
          se.target_segment_id = v_patchids[tv_id] + num_active_vertices - 1;
          se.cut_cost = edge_weights[edge_id];
          segments[sv_id].segment_edges.push_back(se);
          
          if(sv_id < tv_id)
          {
              CutCost cc;           
              cc.seg1_id = sv_id;              
              cc.seg2_id = v_patchids[tv_id] + num_active_vertices - 1;
			  cc.ncut_cost = edge_weights[edge_id];
              sorted_edges.push(cc);
          }   
      }
  }

  printf("init segment done!\n");
  
  //// 迭代num_active_vertices次，即初始有num_active_vertices+num_segments个class，要求最后剩num_segments个
  //// class，每次迭代合并掉一个class
  //for (int iter  = 0; iter < num_active_vertices; ++iter) {
  //  CutCost top_se; // 选出sorted_edge中cost最小的edge，且满足两个结点都是active的
  //  do {            // 将两个结点至少有一个已经是inactive的cost较小的边全从sorted_edge中pop出
  //    top_se = sorted_edges.top(); // 标记为inactive的结点说明已经合并到其他node中了
  //    sorted_edges.pop();
  //  } while (!segments[top_se.seg1_id].is_active
  //    || !segments[top_se.seg2_id].is_active);

  //  
  //  // Two old segments to be merged， 将cost最小的两个结点合并
  //  GraphSegment &segment1 = segments[top_se.seg1_id];
  //  GraphSegment &segment2 = segments[top_se.seg2_id];

  //  // Place to store the new segment，存储合并后的结点
  //  // 共要迭代num_vertices - num_segments次， 每次迭代都在segment的graph信息后加
  //  // 面积更新为原来的的面积和，标记为active
  //  int new_segment_id = num_active_vertices + num_segments + iter; 
  //  GraphSegment &new_segment = segments[new_segment_id];
  //  new_segment.is_active = true;
  //  
  //  // vertices contained in this new segment
  //  // 将合并前两个class里的点全部存在性的class中
  //  new_segment.vertex_ids = segment1.vertex_ids;
  //  for (unsigned i = 0; i < segment2.vertex_ids.size(); ++i) {
  //    new_segment.vertex_ids.push_back(segment2.vertex_ids[i]);
  //  }

  //  // neighboring segments of this new segment
  //  // 更新这个新的class的相邻class信息，即合并前两个class的相邻信息叠加
  //  set<int> neigh_segmentids;
  //  for (unsigned i = 0; i < segment1.segment_edges.size(); ++i) {
  //    int id = segment1.segment_edges[i].target_segment_id;
  //    if (id != top_se.seg2_id)
  //      neigh_segmentids.insert(id);
  //  }
  //  for (unsigned i = 0; i < segment2.segment_edges.size(); ++i) {
  //    int id = segment2.segment_edges[i].target_segment_id;
  //    if (id != top_se.seg1_id)
  //      neigh_segmentids.insert(id);
  //  }

  //  // Update edges
  //  // 更新active的相邻class与新的class的边的权重信息
  //  for (set<int>::iterator iter_int = neigh_segmentids.begin();
  //    iter_int != neigh_segmentids.end();
  //    ++iter_int) {
  //    GraphSegment &neigh_segment = segments[*iter_int];
  //    vector<SegmentEdge> old_edges = neigh_segment.segment_edges; // 之前与neigh_segment相邻的class
  //    neigh_segment.segment_edges.clear();

  //    SegmentEdge new_edge; // 新建neigh_segment与new_segment间的边
  //    new_edge.target_segment_id = new_segment_id;
  //    new_edge.cut_cost = 0.0;
  //    for (unsigned j = 0; j < old_edges.size(); ++j) {
  //      if (old_edges[j].target_segment_id == top_se.seg1_id) {
  //        new_edge.cut_cost += old_edges[j].cut_cost;
		//  new_edge.cut_cost /= 2;
  //      } else if (old_edges[j].target_segment_id == top_se.seg2_id) {
  //        new_edge.cut_cost += old_edges[j].cut_cost;
		//  new_edge.cut_cost /= 2;
  //      } else { // 若neigh_segment原先的相邻class不是合并的两个中的一个，边保留，否则加到新的边
  //        neigh_segment.segment_edges.push_back(old_edges[j]);
  //      }
  //    }
  //    neigh_segment.segment_edges.push_back(new_edge);

  //    // 同样，将这条新的边加入到new_segment的segment_edges中去
  //    new_edge.target_segment_id = *iter_int;
  //    new_segment.segment_edges.push_back(new_edge);

  //    // Update the queue，将new_edge加入到sorted_edges中
  //    CutCost new_cut;
  //    new_cut.seg1_id = *iter_int;
  //    new_cut.seg2_id = new_segment_id;
  //    new_cut.ncut_cost = new_edge.cut_cost;

  //    sorted_edges.push(new_cut);
  //  }

  //  // Update the tide up，将已经合并的segment标记为inactive
  //  segment1.is_active = false;
  //  segment2.is_active = false;
  //  segment1.segment_edges.clear();
  //  segment1.vertex_ids.clear();
  //  segment2.segment_edges.clear();
  //  segment2.vertex_ids.clear();
  //}

  // 最后的结果存储在标记为active的segment中
  vertex_segmentids->resize(active_vids.size());
  int patch_id = 1;
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