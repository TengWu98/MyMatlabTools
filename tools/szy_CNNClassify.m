function [pred_lb, net] = szy_CNNClassify(tr_images, tr_lb, tt_images)
%% construct convolutional neural network
% constant scalar for the random initial network weights. You shouldn't
% need to modify this.
f=1/100;
net.layers = {} ;
net.layers{end+1} = struct('type', 'conv', ...
    'weights', {{f*randn(9,9,1,10, 'single'), zeros(1, 10, 'single')}}, ...
    'stride', 1, ...
    'pad', 0, ...
    'name', 'conv1');
net.layers{end+1} = struct('type', 'pool', ...
    'method', 'max', ...
    'pool', [7 7], ...
    'stride', 7, ...
    'pad', 0);
net.layers{end+1} = struct('type', 'relu');
net.layers{end+1} = struct('type', 'dropout', 'rate', 0.5);
net.layers{end+1} = struct('type', 'conv', ...
    'weights', {{f*randn(8,8,10,15, 'single'), zeros(1, 15, 'single')}}, ...
    'stride', 1, ...
    'pad', 0, ...
    'name', 'fc1');
% Loss layer
net.layers{end+1} = struct('type', 'softmaxloss');

% Visualize the network
vl_simplenn_display(net, 'inputSize', [64 64 1 50])

%% prepare data
total_images = numel(tr_lb) + numel(tt_lb);
image_size = size(tr_images(:, :, 1));
imdb.images.data   = zeros(image_size(1), image_size(2), 1, total_images, 'single');
imdb.images.labels = zeros(1, total_images, 'single');
imdb.images.set    = zeros(1, total_images, 'uint8');

for i = 1:size(tr_images, 3)
    imdb.images.data(:, :, 1, i) = tr_images(:, :, i);
end
for i = 1:size(tt_images, 3)
    imdb.images.data(:, :, 1, end+1) = tt_images(:, :, i);
end
imdb.images.labels(1, :) = [tr_lb tt_lb];
imdb.images.set(1, :) = [ones(1, numel(tr_lb)), ones(1, numel(tt_lb))];

%% train convolutional neural network
%opts.expDir is where trained networks and plots are saved.
opts.expDir = fullfile('..','data','part1') ;

%opts.batchSize is the number of training images in each batch. You don't
%need to modify this.
opts.batchSize = 50 ;

% opts.learningRate is a critical parameter that can dramatically affect
% whether training succeeds or fails. For most of the experiments in this
% project the default learning rate is safe.
opts.learningRate = 0.00001 ;

% opts.numEpochs is the number of epochs. If you experiment with more
% complex networks you might need to increase this. Likewise if you add
% regularization that slows training.
opts.numEpochs = 300 ;

% An example of learning rate decay as an alternative to the fixed learning
% rate used by default. This isn't necessary but can lead to better
% performance.
% opts.learningRate = logspace(-4, -5.5, 300);
% opts.numEpochs = numel(opts.learningRate);

%opts.continue controls whether to resume training from the furthest
%trained network found in opts.batchSize. If you want to modify something
%mid training (e.g. learning rate) this can be useful. You might also want
%to resume a network that hit the maximum number of epochs if you think
%further training can improve accuracy.
opts.continue = false ;

[net, info] = cnn_train(net, imdb, @getBatch, ...
    opts, ...
    'val', find(imdb.images.set == 2)) ;

fprintf('Lowest validation erorr is %f\n',min(info.val.top1error(:)))

end

function [im, labels] = getBatch(imdb, batch)
%getBatch is called by cnn_train.

%'imdb' is the image database.
%'batch' is the indices of the images chosen for this batch.

%'im' is the height x width x channels x num_images stack of images. If
%opts.batchSize is 50 and image size is 64x64 and grayscale, im will be
%64x64x1x50.
%'labels' indicates the ground truth category of each image.

%This function is where you should 'jitter' data.
% --------------------------------------------------------------------

im = imdb.images.data(:, :, :, batch) ;
labels = imdb.images.labels(1, batch) ;

% Add jittering here before returning im
% r = rand();
% if r < 0.5
%     im = fliplr(im);
% end
end
