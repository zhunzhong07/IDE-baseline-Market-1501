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
run('KISSME/toolbox/init.m');
%addpath(genpath('utils/'));

xqda_learning = 1;
kissme_learning = 1;

k1 = 20;
k2 = 6;
kre = 1;
thea = 0.3;

%% train info
label_train = importdata('data/train_label.mat');
cam_train =  importdata('data/train_cam.mat');
train_feature = importdata('feat/ide_train_resnet50_lloss.mat');
train_feature = double(train_feature);
%% test info
galFea =  importdata('feat/ide_test_resnet50_lloss.mat');
galFea = double(galFea);
probFea =  importdata('feat/ide_query_resnet50_lloss.mat');
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


%% train


%% Eulc

dist_eu = pdist2(galFea', probFea');
[CMC_eu, map_eu, r1_pairwise, ap_pairwise] = evaluation_mars(dist_eu, label_gallery, label_query, cam_gallery, cam_query);

dist_eu_re = new_sca( [probFea galFea], 1, 1, size(probFea, 2), k1, k2, 1, thea);
[CMC_eu_re, map_eu_re, r1_pairwise_re, ap_pairwise_re] = evaluation_mars(dist_eu_re, label_gallery, label_query, cam_gallery, cam_query);
%
%

%% train and test XQDA

if xqda_learning == 1
    [train_sample1, train_sample2, label1, label2] = gen_train_sample_xqda(label_train, cam_train, train_feature); % generate pairwise training features for XQDA
    [W, M_xqda] = XQDA(train_sample1, train_sample2, label1, label2);% train XQDA
    
    %save(['metric/ide_resnet50_xqda.mat'], 'W', 'M_xqda');
else
    %load(['metric/ide_resnet50_xqda.mat']);
end

%

dist_xqda = MahDist(M_xqda, galFea' * W, probFea' * W); % calculate MahDist between query and gallery boxes with learnt subspace. Smaller distance means larger similarity
%dist_xqda = pdist2(galFea, probFea);
[CMC_xqda, map_xqda, r1_pairwise, ap_pairwise] = evaluation_mars(dist_xqda, label_gallery, label_query, cam_gallery, cam_query);

dist_xqda_re = new_sca( [probFea galFea], M_xqda, W, size(probFea, 2), k1, k2, 1, thea);
[CMC_xqda_re, map_xqda_re, r1_pairwise_re, ap_pairwise_re] = evaluation_mars(dist_xqda_re, label_gallery, label_query, cam_gallery, cam_query);
%


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
if kissme_learning == 1
    [idxa,idxb,flag] = gen_train_sample_kissme(label_train, cam_train); % generate pairwise training features for kissme
    
    [M_kissme, M_mahal, M_eu] = KISSME(pair_metric_learn_algs, ux_train, ux_gallery, ux_query, idxa, idxb, flag);
    
        %save(['metric/ide_resnet50_kissme.mat'], 'M_kissme');
    else
        %load(['metric/ide_resnet50_kissme.mat']);  
end

% Calculate distance
dist_kissme = MahDist(M_kissme, ux_gallery', ux_query');
[CMC_kissme, map_kissme, r1_pairwise, ap_pairwise] = evaluation_mars(dist_kissme, label_gallery, label_query, cam_gallery, cam_query);

dist_kissme_re = new_sca( [ux_query ux_gallery], M_kissme, 1, size(ux_query, 2), k1, k2, 1, thea);
[CMC_kissme_re, map_kissme_re, r1_pairwise_re, ap_pairwise_re] = evaluation_mars(dist_kissme_re, label_gallery, label_query, cam_gallery, cam_query);


