function fit_encoding_model_supplementary_sensitivity_tempThing(model,layer,region,dimension)
% Take features extracted by a specified layer of ANN (EmoNet
% or EmoFAN) to predict amygdala activity from BOLD data acquired from
% subjects watching Game of Thrones (OpenNeuro ds 004848)

% Usage:
% ::
%
%   fit_encoding_model_supplementary(model,layer,region)
%
% ..
%     Author and copyright information:
%
%     Copyright (C) 2024 Katherine Soderberg and Philip Kragel
%
%     This program is free software: you can redistribute it and/or modify
%     it under the terms of the MIT License, or (at your option) any later
%     version.
%
%     This program is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
%
% ..
% :Inputs:
%   **model** - string indicating the ANN to use to extract features
%   ('emonet', 'emofan', or 'combined')
%   **layer** - string indicating the layers to use for analysis ('late',
%   or 'intermediate')
%   **region** - string indicating the ROI to predict
%   ('Amy' or 'STS')
%   **dimension** - numeric indicating the dimensionality of the PLS regression
%   (20, 50, 100, 200)

% note: you will need CanlabCore on your path %addpath(genpath('~/GitHub'))

%% set up some paths

addpath('/home/data/eccolab/Code/NNDb/SEE/feature_extraction/supplementary')
fmri_data_path = '/home/data/eccolab/OpenNeuro/ds004848/data';


% note: can specify output directory here for saving files
output_directory = '/home/data/eccolab/Code/NNDb/SEE/outputs/supplementary';

%% parse inputs and load extracted features

%region to model
if strcmp(region,'Amy')
    rcell = {region};
elseif strcmp(region,'pSTS')
    rcell = {'STSvp','STSdp'};
elseif strcmp(region,'FFA')
    rcell = {'FFC'};
elseif strcmp(region,'OFA')
    rcell={'PIT'};
elseif strcmp(region,'V1')
    rcell={'Ctx_V1'};
else
    error('Please specify region as either "Amy" , "pSTS", "FFA", "OFA", or "V1"')
end


% ANNs and specific layers to use for feature extraction
if strcmp(model, 'emonet')
    if strcmp(layer,'late')
	dim = 20;
        video_imageFeatures = load(which('Game_of_Thrones_fc8_features.mat'));
        video_imageFeatures = video_imageFeatures.video_imageFeatures;
        video_imageFeatures = video_imageFeatures(6:end,:);
        keyword = 'emonet_late';
    elseif strcmp(layer, 'intermediate')
	dim = dimension;
        video_imageFeatures = load(which('Game_of_Thrones_fc7_features.mat'));
        video_imageFeatures = video_imageFeatures.video_imageFeatures;
        video_imageFeatures = video_imageFeatures(6:end,:);
        keyword = 'emonet_intermediate';
    end
    lendelta = size(video_imageFeatures, 1);

elseif strcmp(model, 'emofan')
    if strcmp(layer,'late')
	dim = 10;
        t = readtable(which('emofan_late_GoT.txt'));
        video_imageFeatures = table2array(t);
        %put in the subtraction of the image features, 24 frames
        video_imageFeatures = video_imageFeatures(25:end,:);
        keyword = 'emofan_late';
    elseif strcmp(layer, 'intermediate')
        dim = dimension;
	t = readtable(which('emofan_intermediate_GoT.txt'));
        video_imageFeatures = table2array(t);
        %put in the subtraction of the image features, 24 frames
        video_imageFeatures = video_imageFeatures(25:end,:);
        keyword = 'emofan_intermediate';
    end
    lendelta = size(video_imageFeatures, 1);
elseif strcmp(model,'combined')
    if strcmp(layer,'late')
	dim = 20;
        t=readtable(which('emofan_late_GoT.txt'));
        video_imageFeatures_fan = table2array(t);
        video_imageFeatures_fan = video_imageFeatures_fan(25:end,:);
        lendelta_fan = size(video_imageFeatures_fan, 1);
        video_imageFeatures = load(which('Game_of_Thrones_fc8_features.mat'));
        video_imageFeatures = video_imageFeatures.video_imageFeatures;
        %put in the subtraction of the image features, 24 / 5 frames
        video_imageFeatures = video_imageFeatures(6:end,:);
        keyword = 'combined_late';
    elseif strcmp(layer, 'intermediate')
	dim = dimension;
        t=readtable(which('emofan_intermediate_GoT.txt'));
        video_imageFeatures_fan = table2array(t);
        video_imageFeatures_fan = video_imageFeatures_fan(25:end,:);
        lendelta_fan = size(video_imageFeatures_fan, 1);
        video_imageFeatures = load(which('Game_of_Thrones_fc7_features.mat'));
        video_imageFeatures = video_imageFeatures.video_imageFeatures;
        %put in the subtraction of the image features, 24 / 5 frames
        video_imageFeatures = video_imageFeatures(6:end,:);
        keyword = 'combined_intermediate';
    end
        
lendelta = size(video_imageFeatures, 1);

else
    error('The inputs you have provided are invalid. Possible inputs for "model" are "emonet", "emofan", and "combined". Possible inputs for "layer" are "late" and "intermediate".')
end

%% Perform the analysis using the loaded data
%an array to iterate all the subjects
subjects = {'01' '02' '03' '04' '05' '06' '07' '08' '09' '10' '11' '12' '13' '14' '15' '16' '17' '18' '19' '20' '21' '22' '23' '24' '25' '26' '27' '28' '29' '30' '31' '32' '33' '34' '35' '36' '37' '38' '39' '40' '41' '42' '43' '44' '45'};

%loop through all subjects
for s = 26:length(subjects)

    %load BOLD data for each subject
    dat = fmri_data([fmri_data_path filesep 'sub-control' subjects{s} filesep 'func' filesep 'sub-control' subjects{s} '_task-GoT_space-MNI152NLin2009cAsym_res-2_desc-preproc_bold_smooth.nii.gz']);

    %mask BOLD data to isolate ROI voxels ONLY


    masked_dat = apply_mask(dat,select_atlas_subset(load_atlas('canlab2018'),rcell));
    if strcmp(region,'Amy')
	excluded_voxels(s,:) = masked_dat.removed_voxels;
    end
    disp('masked_dat done')

    %UPDATED: this line resamples size of imagefeatures (video_imageFeatures) by row (182) to the size of the BOLD data (masked_dat.dat) by column (5470): resample = data resized by p/q: resample(data, p, q)
    features = resample(double(video_imageFeatures),size(masked_dat.dat,2),lendelta);
    if strcmp(model,'combined')
        features = [features resample(double(video_imageFeatures_fan),size(masked_dat.dat,2),lendelta_fan)];
    end
    disp('resample features done')

    %This loop convolutes the video image features to match time delay of hemodynamic BOLD data
    for i = 1:size(features, 2) %for each column (timeseries) of NN output (...features.mat)

        %assign a corresponding column in a convolved output matrix, after convolving with spm's hrf
        tmp = conv(double(features(:,i)), spm_hrf(1));

        %UPDATED
        %X(:,i) = tmp(1:lendelta);
        conv_features(:,i) = tmp(:);

    end

    %UPDATED(x2): this line matches/cuts the length of conv_features to match with length of BOLD data
    timematched_features = conv_features(1:size(masked_dat.dat,2),:);
    disp('timematched_features done')

    %UPDATED to extract and save betas
    [~,~,~,~,b] = plsregress(timematched_features,masked_dat.dat',dim); % b = regression coefficient (beta)
    disp('beta done')


    % estimate noise ceiling using resubstitution
    yhat_resub=[ones(size(timematched_features,1),1) timematched_features]*b;
    disp('yhat done')

    pred_obs_corr_resub=corr(yhat_resub, masked_dat.dat');
    disp('pred_obs_corr done')

    diag_corr_resub=diag(pred_obs_corr_resub);
    disp('diag_corr done')

    mean_diag_corr_resub(s,:) = mean(diag_corr_resub);


    kinds = crossvalind('k',size(masked_dat.dat,2),5);
    disp('kinds done')

    clear yhat pred_obs_corr diag_corr conv_features

    for k=1:5

        [~,~,~,~,beta_cv] = plsregress(timematched_features(kinds~=k,:), masked_dat.dat(:,kinds~=k)', min(dim,size(masked_dat.dat,1))); %size(masked_dat.dat,1)=252
        disp('plsregress done')

        yhat(kinds==k,:)=[ones(length(find(kinds==k)),1) timematched_features(kinds==k,:)]*beta_cv;
        disp('yhat done')

        pred_obs_corr(:,:,k)=corr(yhat(kinds==k,:), masked_dat.dat(:,kinds==k)');
        disp('pred_obs_corr done')

        diag_corr(k,:)=diag(pred_obs_corr(:,:,k));
        disp('diag_corr done')

    end


    mean_diag_corr = mean(diag_corr); %estimate the average correlation between observed and predicted values

    %save([output_directory filesep 'sub-' subjects{s} '_' region '_' model '_' layer '_yhat.mat'], 'yhat', '-v7.3') %save performance measures for each subject


    save([output_directory filesep 'sub-' subjects{s} '_' region '_' model '_' layer '_dim' num2str(dimension) '_mean_diag_corr.mat'], 'mean_diag_corr', '-v7.3') %save performance measures for each subject

    save([output_directory filesep 'beta_sub-' subjects{s} '_' region '_' model '_' layer '_dim' num2str(dimension) '_mean_diag_corr.mat'], 'b', '-v7.3') %save betas for each subject

end

%% if amygdala analysis done, save out the exluded voxels
if strcmp(region,'Amy')
    save([output_directory filesep 'dim_' num2str(dimension) 'amygdala_excluded_voxels.mat'], 'excluded_voxels')
end

