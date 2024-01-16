feature_name = {'logsdf','logagd','cg', 'lps', 'hsc','curv'};
feature_dim = [100 100 100 3 100 100];

dir = 'D:\Co-seg_mine\Testing\061_080_airplane';
[model_name patch_num] = readmodel(dir);
tune_para(dir, model_name, patch_num, feature_name, feature_dim, 3);
tune_para(dir, model_name, patch_num, feature_name, feature_dim, 2);

dir = 'D:\Co-seg_mine\Testing\181_200_hand';
[model_name patch_num] = readmodel(dir);
tune_para(dir, model_name, patch_num, feature_name, feature_dim, 2);

dir = 'D:\Co-seg_mine\Testing\281_300_armadillo';
[model_name patch_num] = readmodel(dir);
tune_para(dir, model_name, patch_num, feature_name, feature_dim, 5);

