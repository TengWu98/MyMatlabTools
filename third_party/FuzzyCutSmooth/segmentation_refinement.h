#ifndef segmentation_refinement_h_
#define segmentation_refinement_h_

#include <vector>
#include <algorithm>
#include <queue>
#include <math.h>
#include <vector>
#include <set>
using namespace std;

bool BoundaryDistance(const int *edge_fids,
  const int &num_edges,
  const int *face_patchids,
  const int &num_faces,
  vector<int> *face_depth);

void BoundaryDistance(const int *edge_fids,
  const int &num_edges,
  const double *face_centers,
  const int *face_patchids,
  const int &num_faces,
  vector<double> *face_depth);

void GeneratePatches(const int *edge_fids,
  const int &num_edges,
  const double *face_coords,
  const int &dimension,
  const int &num_faces,
  const int *patch_center_ids,
  const int *initial_face_patchids,
  const int &num_patches,
  vector<int> *face_patchids);

/* define a Height class */
struct PatchDistance {
 public:
  PatchDistance() {
    face_id = -1;
    patch_id = -1;
    distance = 0.0; // face_id 到 patch_id的距离
  }
  inline PatchDistance(int fid, int pid, double dis) {
    face_id = fid;
    patch_id = pid;
    distance = dis;
  }
  bool operator < (const PatchDistance &) const; // overloaded < operator

  int face_id;
  int patch_id;
  double distance;
};

/* overload the less-than operator so priority queues know how to compare two Height objects */
bool PatchDistance::operator < (const PatchDistance &right) const { // 与patch的距离越远在queue中就越小
  if (distance > right.distance) {
    return true;
  } else if (distance < right.distance) {
    return false;
  } else {
    return face_id > right.face_id;
  }
}


bool BoundaryDistance(const int *edge_fids,
  const int &num_edges,
  const int *face_patchids,
  const int &num_faces,
  vector<int> *face_depth) {
  vector<int> face_top;
  face_top.resize(3*num_faces);
  for (int id = 0; id < 3*num_faces; ++id)
    face_top[id] = -1;

  for (int e_id = 0; e_id < num_edges; ++e_id) {
    int f1_id = edge_fids[2*e_id];
    int f2_id = edge_fids[2*e_id+1];
    for (int i = 0; i < 3; ++i) {
      if (face_top[3*f1_id+i] == -1) {
        face_top[3*f1_id+i] = f2_id; // face_top记录的是与各个face相邻的face指标，每个face都有3个相邻的face
        break;
      }
    }
  }

  vector<int> fringe;
  fringe.resize(num_faces);

  face_depth->resize(num_faces);
  int num_visited = 0;
  for (int f_id = 0; f_id < num_faces; ++f_id) {
    (*face_depth)[f_id] = -1;
    bool boundary = false;
    for (int i = 0; i < 3; ++i) {
      if (face_top[3*f_id+i] != -1
        && face_patchids[f_id] != face_patchids[face_top[3*f_id+i]]) {
        boundary = true;
        break;
      }
    }
    if (boundary) { // 若face位于segment的边界处，即有相邻的face的segment指标不一样
      (*face_depth)[f_id] = 1;  // 此face的depth为1
      fringe[num_visited] = f_id; // 并记录此face的指标于fringe
      num_visited++;
    }
  }

  // 再由fringe一圈圈往里遍历，依次加大depth，因此depth最大的既是中心face
  int fringe_start = 0, fringe_end = num_visited, depth = 1;
  while (fringe_start < fringe_end) {
    depth++;
    for (int j = fringe_start; j < fringe_end; ++j) {
      int f_id = fringe[j];
      for (int i = 0; i < 3; ++i) {
        int n_id = face_top[3*f_id+i];
        if (n_id >= 0 && (*face_depth)[n_id] == -1) {
          (*face_depth)[n_id] = depth;
          fringe[num_visited] = n_id;
          num_visited++;
        }
      }
    }
    fringe_start = fringe_end;
    fringe_end = num_visited;
  }
  return true;
}

void BoundaryDistance(
  const int *edge_fids,
  const int &num_edges,
  const double *face_centers,
  const int *face_patchids,
  const int &num_faces,
  vector<double> *face_depth) {

}

void GeneratePatches( // 生成新的segment
  const int *edge_fids,
  const int &num_edges,
  const double *face_coords,
  const int &dimension,
  const int &num_faces,
  const int *patch_center_ids,
  const int *initial_face_patchids,
  const int &num_patches,
  vector<int> *face_patchids) {
  vector<int> face_top;
  face_top.resize(3*num_faces); // face_top记录的是与各个face相邻的face指标，每个face都有3个相邻的face
  for (int id = 0; id < 3*num_faces; ++id)
    face_top[id] = -1;

  for (int e_id = 0; e_id < num_edges; ++e_id) {
    int f1_id = edge_fids[2*e_id];
    int f2_id = edge_fids[2*e_id+1];
    for (int i = 0; i < 3; ++i) {
      if (face_top[3*f1_id+i] == -1) {
        face_top[3*f1_id+i] = f2_id;
        break;
      }
    }
  }

  face_patchids->resize(num_faces);
  for (int face_id = 0; face_id < num_faces; ++face_id) {
    (*face_patchids)[face_id] = initial_face_patchids[face_id];
  }

  vector<vector<bool>> flags;
  flags.resize(num_patches); //记录每个segment对应的face指标，初始全部为true，设为false说明face属于这个segment
  for (int patch_id = 0; patch_id < num_patches; ++patch_id) {
    flags[patch_id].resize(num_faces);
    for (int face_id = 0; face_id < num_faces; ++face_id) {
      flags[patch_id][face_id] = true;
    }
  }

  priority_queue<PatchDistance> pd_queue;
  for (int face_id = 0; face_id < num_faces; ++face_id) {
      if (initial_face_patchids[face_id] >= 0) { 
          int patch_id = initial_face_patchids[face_id];
          flags[patch_id][face_id] = false;
          pd_queue.push(PatchDistance(face_id, patch_id, 0.0)); }// 将已经确认的face-segment对存入queue
  }//此时，只有active的face没有对应好segment

  while (!pd_queue.empty()) { //若queue非空
    PatchDistance head = pd_queue.top();
    pd_queue.pop();
    if ((*face_patchids)[head.face_id] == -1) { // 若之前face无对应segment指标，则赋予queue中pop出得的
      (*face_patchids)[head.face_id] = head.patch_id; // 即将最近的segment找到赋给它
    }
    for (int i = 0; i < 3; ++i) { 
      int n_id = face_top[3*head.face_id + i];
      if (n_id >= 0 && flags[head.patch_id][n_id] && (*face_patchids)[n_id] == -1) {
        double dis2 = 0.0; //这个face周围的3个face若还未赋予指标，且为考虑以segment [head.patch_id]进queue
        int foot_face_id = patch_center_ids[head.patch_id];// 得到segment [head.patch_id]的中心face指标
        for (int k = 0; k < dimension; ++k) { // 计算这个face对应的coordinate于中心face coordinate的欧氏距离
          double d = face_coords[dimension*n_id + k] // 这个距离即为面片到segment的距离
          - face_coords[dimension*foot_face_id + k];
          dis2 += d*d;
        }
        pd_queue.push(PatchDistance(n_id, head.patch_id, dis2));
        flags[head.patch_id][n_id] = false;
      }
    }
  }
}
#endif