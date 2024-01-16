%% 将tr_dat转化为Matlab深度学习框架所能接受的4D矩阵X_Train训练样本
function X_Train = szy_Convert_tr_dat_To_X_Train_For_DeepLearning(tr_dat)
for i = 1:size(tr_dat, 2)
    X_Train(1, :, 1, i) = tr_dat(:, i)';
end