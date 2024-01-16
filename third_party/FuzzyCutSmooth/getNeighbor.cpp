#include <iostream>
#include <stdio.h>
#include <stdlib.h>
#include <map>
#include <set>
#include <string>
#include <iterator>
#include <algorithm>
using namespace std;
map<int, set<int> > index;  //倒排索引
set<int>::iterator it;
int data[100000][3];      
map<int, int> segment;   //key:faces_index,value:segment
map<int, int> has;     //判重
void read_segment(char* filename){
	int tmp, idx = 0;
    freopen(filename,"r",stdin);
    while (scanf("%d", &tmp) != EOF){
	    segment[idx ++] = tmp;
	}
}
int main(int argc,char *argv[]){
	if (argc < 4){
	    printf("Usage:getNeighbor <label_path> <input_path> <output_path>");
		exit(-1);
	}
	read_segment(argv[1]);
	freopen(argv[2],"r",stdin);
    freopen(argv[3],"w",stdout);

	int x[3];
	int idx = 0;
    while (scanf("%d%d%d", &x[0], &x[1], &x[2]) != EOF){   //建立倒排索引
		for (int i = 0; i < 3; i ++){
			data[idx][i] = x[i];
		    if (index.find(x[i]) == index.end()){
		        index[x[i]] = set<int>();
			}
			index[x[i]].insert(idx);
		}
		idx ++;
	}
	for (int i = 0; i < idx; i ++){
		set<int> tmp1 = set<int>();
        set<int> tmp2 = set<int>();
		set<int> tmp3 = set<int>();
		set<int> tmp4 = set<int>();
		set<int> ret = set<int>();
        set_intersection(index[data[i][0]].begin(), index[data[i][0]].end(), index[data[i][1]].begin(), index[data[i][1]].end(), inserter(tmp1, tmp1.begin())); 	
	    set_intersection(index[data[i][0]].begin(), index[data[i][0]].end(), index[data[i][2]].begin(), index[data[i][2]].end(), inserter(tmp2, tmp2.begin())); 	
	    set_intersection(index[data[i][1]].begin(), index[data[i][1]].end(), index[data[i][2]].begin(), index[data[i][2]].end(), inserter(tmp3, tmp3.begin())); 
		set_union(tmp1.begin(), tmp1.end(), tmp2.begin(), tmp2.end(), inserter(tmp4, tmp4.begin()));
        set_union(tmp4.begin(), tmp4.end(), tmp3.begin(), tmp3.end(), inserter(ret, ret.begin()));
		for (it = ret.begin();it != ret.end(); it ++){
//			if (*it > i){
//			    printf("%d %d\n", i, *it);
//          }
			int hashcode = segment[i]*100 + segment[*it];       //输出相邻segment编号
			if (segment[i] < segment[*it] && has.find(hashcode) == has.end()){
                has[hashcode] = 1;
                printf("%d %d\n", segment[i], segment[*it]);
			}
		}
	}
    return 0;
}