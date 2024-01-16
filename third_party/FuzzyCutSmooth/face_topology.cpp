#include <algorithm>
#include <vector>
#include <set>
using namespace std;

#include "face_topology.h"

void ComputeFaceTopology(
  const int *f_vids,
  const int &num_faces,
  vector<int> *edge_fid_1,
  vector<int> *edge_fid_2) {
  int num_vertices = 0;
  for (int id = 0; id < 3*num_faces; ++id) {
    if (f_vids[id]+1>=num_vertices)
      num_vertices = f_vids[id]+1;
  }
  vector<Vertex> vertices;
  vector<Edge> edges;
  vector<Face> faces;

  vertices.resize(num_vertices);
  faces.resize(num_faces);

  edges.resize(3*num_faces);
  for (int f_id = 0; f_id < num_faces; ++f_id) {
    Face &face = faces[f_id];
    Edge &edge1 = edges[3*f_id];
    Edge &edge2 = edges[3*f_id+1];
    Edge &edge3 = edges[3*f_id+2];

    face.first_edge_id = 3*f_id;
    edge1.left_face_id = edge2.left_face_id = edge3.left_face_id = f_id;
    edge1.next_edge_id = face.first_edge_id + 1;
    edge1.prev_edge_id = face.first_edge_id + 2;
    edge2.next_edge_id = face.first_edge_id + 2;
    edge2.prev_edge_id = face.first_edge_id;
    edge3.next_edge_id = face.first_edge_id;
    edge3.prev_edge_id = face.first_edge_id + 1;

    edge1.start_vertex_id	= f_vids[3*f_id];
    Vertex	&v1 = vertices[edge1.start_vertex_id];
    v1.edge_id	= face.first_edge_id;

    edge2.start_vertex_id	= f_vids[3*f_id+1];
    Vertex	&v2 = vertices[edge2.start_vertex_id];
    v2.edge_id	= face.first_edge_id + 1;

    edge3.start_vertex_id	= f_vids[3*f_id+2];
    Vertex	&v3 = vertices[edge3.start_vertex_id];
    v3.edge_id	= face.first_edge_id + 2;
  }

  vector<vector<int>>	edgeNeighs;
  edgeNeighs.resize(num_vertices);

  for (int f_id = 0; f_id < num_faces; f_id++) {
    Face	&face	= faces[f_id];
    int		eId1	= face.first_edge_id;
    Edge	&edge1	= edges[eId1];
    int		eId2	= edge1.next_edge_id;
    Edge	&edge2	= edges[eId2];
    int		eId3	= edge1.prev_edge_id;
    Edge	&edge3  = edges[eId3];
    edgeNeighs[edge1.start_vertex_id].push_back(eId1);
    edgeNeighs[edge2.start_vertex_id].push_back(eId2);
    edgeNeighs[edge3.start_vertex_id].push_back(eId3);
  }

  for (unsigned e_id = 0; e_id < edges.size(); ++e_id) {
    Edge	&edge = edges[e_id];
    edge.SetIsBoundaryFlag(true);
  }

  for(int v_id = 0; v_id < num_vertices; v_id++) {
    vector<int>	&neighs = edgeNeighs[v_id];
    for (unsigned j = 0; j < neighs.size(); ++j) {
      int e_id = neighs[j];
      Edge	&edge = edges[e_id];
      if(!edge.GetIsBoundaryFlag())
        continue;
      Edge	&edge_next = edges[edge.next_edge_id];
      bool	flag = false;
      vector<int>	&neighs_end = edgeNeighs[edge_next.start_vertex_id];
      for (unsigned k = 0; k < neighs_end.size(); ++k) {
        int	twin_e_id = neighs_end[k];
        Edge	&twin_edge = edges[twin_e_id];
        Edge	&twin_edge_next = edges[twin_edge.next_edge_id];
        if(v_id == twin_edge_next.start_vertex_id) {
          flag = true;
          edge.twin_edge_id	= twin_e_id;
          twin_edge.twin_edge_id = e_id;
          edge.SetIsBoundaryFlag(false);
          twin_edge.SetIsBoundaryFlag(false);
          break;
        }
      }
      if(!flag) {
        Edge	newEdge;
        edge.twin_edge_id		= int(edges.size());
        newEdge.twin_edge_id	= e_id;
        newEdge.start_vertex_id	= edge_next.start_vertex_id;
        newEdge.prev_edge_id	=	-1;
        newEdge.next_edge_id	=	-1;
        newEdge.left_face_id	=	-1;
        newEdge.SetIsBoundaryFlag(true);
        edges.push_back(newEdge);
      }
    }
  }

  //start the construction
  int nBV = 0;
  for (int v_id = 0; v_id < num_vertices; v_id++) {
    Vertex	&vertex = vertices[v_id];
    vertex.SetIsBoundaryFlag(false);
    int	first_e_id = vertex.edge_id;
    int	e_id = first_e_id;
    do {
      Edge	&edge = edges[e_id];
      Edge	&twinedge = edges[edge.twin_edge_id];
      if(twinedge.next_edge_id >= 0) {
        e_id = twinedge.next_edge_id;
      } else {
        vertex.edge_id = e_id;
        vertex.SetIsBoundaryFlag(true);
        nBV++;
        break;
      }
    } while(e_id != first_e_id);
  }

  // Now we are ready to compute the face topology
  edge_fid_1->resize(3*num_faces);
  edge_fid_2->resize(3*num_faces);
  int num_edges = 0;
  for (int f_id = 0; f_id < num_faces; ++f_id) {
    Face &face = faces[f_id];
    const Edge &e1 = edges[face.first_edge_id];
    const Edge &twin_e1 = edges[e1.twin_edge_id];
    if (twin_e1.left_face_id >= 0) {
      (*edge_fid_1)[num_edges] = f_id;
      (*edge_fid_2)[num_edges] = twin_e1.left_face_id;
      num_edges++;
    }
    Edge &e2 = edges[e1.next_edge_id];
    const Edge &twin_e2 = edges[e2.twin_edge_id];
    if (twin_e2.left_face_id >= 0) {
      (*edge_fid_1)[num_edges] = f_id;
      (*edge_fid_2)[num_edges] = twin_e2.left_face_id;
      num_edges++;
    }
    Edge &e3 = edges[e1.prev_edge_id];
    const Edge &twin_e3 = edges[e3.twin_edge_id];
    if (twin_e3.left_face_id >= 0) {
      (*edge_fid_1)[num_edges] = f_id;
      (*edge_fid_2)[num_edges] = twin_e3.left_face_id;
      num_edges++;
    }
  }
  edge_fid_1->resize(num_edges);
  edge_fid_2->resize(num_edges);
}
