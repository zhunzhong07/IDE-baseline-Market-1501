clc;clear all;close all;
%***********************************************%
% This code runs on the Market-1501 dataset.    %
% Please modify the path to your own folder.    %
% We use the mAP and hit-1 rate as evaluation   %
%***********************************************%
% if you find this code useful in your research, please kindly cite our
% paper as,
% Liang Zheng, Liyue Sheng, Lu Tian, Shengjin Wang, Jingdong Wang, and Qi Tian,
% Scalable Person Re-identification: A Benchmark, ICCV, 2015.

% Please download Market-1501 dataset and unzip it in the "dataset" folder.
addpath(genpath('LOMO_XQDA/'));
addpath(genpath('utils/'));
addpath(genpath('KISSME/'));
run('KISSME/toolbox/init.m');

%% network name
netname = 'ResNet_50'; % network: CaffeNet  or ResNet_50

%% train info
label_train = importdata('data/train_label.mat');
cam_train =  importdata('data/train_cam.mat');
train_feature = importdata(['feat/IDE_' netname '_train.mat']);
train_feature = double(train_feature);
%% test info
galFea = importdata(['feat/IDE_' netname '_test.mat']);
galFea = double(galFea);
probFea = importdata(['feat/IDE_' netname '_query.mat']);
probFea = double(probFea);
label_gallery = importdata('data/testID.mat');
label_query = importdata('data/queryID.mat');
cam_gallery =   importdata('data/testCam.mat');
cam_query =  importdata('data/queryCam.mat');



%% normalize
sum_val = sqrt(sum(galFea.^2));
for n = 1:size(galFea, 1)
    galFea(n, :) = galFea(n, :)./sum_val;
end

sum_val = sqrt(sum(probFea.^2));
for n = 1:size(probFea, 1)
    probFea(n, :) = probFea(n, :)./sum_val;
end

sum_val = sqrt(sum(train_feature.^2));
for n = 1:size(train_feature, 1)
    train_feature(n, :) = train_feature(n, :)./sum_val;
end

% Instead of pdist2. 50 times faster than pdist2
my_pdist2 = @(A, B) sqrt( bsxfun(@plus, sum(A.^2, 2), sum(B.^2, 2)') - 2*(A*B'));
%% Euclidean

dist_eu = my_pdist2(galFea', probFea');
[CMC_eu, map_eu, ~, ~] = evaluation(dist_eu, label_gallery, label_query, cam_gallery, cam_query);

fprintf(['The IDE (' netname ') + Euclidean performance:\n']);
fprintf(' Rank1,  mAP\n');
fprintf('%5.2f%%, %5.2f%%\n\n', CMC_eu(1) * 100, map_eu(1)*100);

%% train and test XQDA
[train_sample1, train_sample2, label1, label2] = gen_train_sample_xqda(label_train, cam_train, train_feature); % generate pairwise training features for XQDA
[W, M_xqda] = XQDA(train_sample1, train_sample2, label1, label2);% train XQDA
% Calculate distance
dist_xqda = MahDist(M_xqda, galFea' * W, probFea' * W); % calculate MahDist between query and gallery boxes with learnt subspace. Smaller distance means larger similarity
[CMC_xqda, map_xqda, ~, ~] = evaluation(dist_xqda, label_gallery, label_query, cam_gallery, cam_query);

fprintf(['The IDE (' netname ') + XQDA performance:\n']);
fprintf(' Rank1,  mAP\n');
fprintf('%5.2f%%, %5.2f%%\n\n', CMC_xqda(1) * 100, map_xqda(1)*100);

%%  train and test kissme
params.numCoeffs = 200; %dimensionality reduction by PCA to 200 dimension
pair_metric_learn_algs = {...
    LearnAlgoKISSME(params), ...
    LearnAlgoMahal(), ...
    LearnAlgoMLEuclidean()
    };

% dimension reduction by PCA
[ux_train,u,m] = applypca2(train_feature);
ux_gallery = u'*(galFea-repmat(m,1,size(galFea,2)));
ux_query = u'*(probFea-repmat(m,1,size(probFea,2)));
ux_train = ux_train(1:params.numCoeffs,:);
ux_gallery = ux_gallery(1:params.numCoeffs,:);
ux_query = ux_query(1:params.numCoeffs,:);

% Metric learning
[idxa,idxb,flag] = gen_train_sample_kissme(label_train, cam_train); % generate pairwise training features for kissme
[M_kissme, M_mahal, M_eu] = KISSME(pair_metric_learn_algs, ux_train, ux_gallery, ux_query, idxa, idxb, flag);

% Calculate distance
dist_kissme = MahDist(M_kissme, ux_gallery', ux_query');
[CMC_kissme, map_kissme, ~, ~] = evaluation(dist_kissme, label_gallery, label_query, cam_gallery, cam_query);

fprintf(['The IDE (' netname ') + KISSME performance:\n']);
fprintf(' Rank1,  mAP\n');
fprintf('%5.2f%%, %5.2f%%\n\n', CMC_kissme(1) * 100, map_kissme(1)*100);
