% Take features extracted by a specified layer of ANN (EmoNet
% or EmoFAN) to predict amygdala activity from BOLD data acquired from
% NNDb.

% note: you will need CanlabCore on your path %addpath(genpath('~/GitHub'))

%% set up some paths
% note: update these paths with the folder you downloaded
emofan_features_path = '[YOUR PATH HERE]/demo_data/emonet/500_days_of_summer_fc8_features.mat';
emonet_features_path = '[YOUR PATH HERE]/demo_data/500_days_of_summer_fc7_features.mat';
fmri_data_path = '[YOUR PATH HERE]/demo_data/';


% note: can specify output directory here for saving files
output_directory = '[YOUR PATH HERE]/outputs/';

%% parse inputs and load extracted features

%% Perform the analysis using the loaded data
video_imageFeatures = load("500_days_of_summer_fc8_features.mat");
t = readtable('emonet_face_output_NNDB_lastFC.txt');
video_imageFeatures_fan = table2array(t);
lendelta = size(video_imageFeatures, 1);
lendelta_fan = size(video_imageFeatures_fan, 1);
    %load BOLD data for each subject
    dat = fmri_data([fmri_data_path filesep 'sub-1_task-500daysofsummer_bold_blur_censor.nii.gz']);

    %mask BOLD data to isolate pSTS voxels ONLY

    masked_dat = apply_mask(dat,select_atlas_subset(load_atlas('canlab2018'),{'STSvp','STSdp'}));

    disp('masked_dat done')

    %UPDATED: this line resamples size of imagefeatures (video_imageFeatures) by row (182) to the size of the BOLD data (masked_dat.dat) by column (5470): resample = data resized by p/q: resample(data, p, q)
    features = resample(double(video_imageFeatures),size(masked_dat.dat,2),lendelta);
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
    [~,~,~,~,b] = plsregress(timematched_features,masked_dat.dat',20); % b = regression coefficient (beta)
    disp('beta done')


    % estimate noise ceiling for resubstitution
    yhat_resub=[ones(length(kinds),1) timematched_features]*b;
    disp('yhat done')

    pred_obs_corr_resub=corr(yhat_resub, masked_dat.dat');
    disp('pred_obs_corr done')

    diag_corr_resub=diag(pred_obs_corr_resub);
    disp('diag_corr done')

    mean_diag_corr_resub(s,:) = mean(diag_corr_resub);


    kinds = crossvalind('k',length(masked_dat.dat),5);
    disp('kinds done')

    clear yhat pred_obs_corr diag_corr conv_features

    for k=1:5

        [~,~,~,~,beta_cv] = plsregress(timematched_features(kinds~=k,:), masked_dat.dat(:,kinds~=k)', min(20,size(masked_dat.dat,1))); %size(masked_dat.dat,1)=252
        disp('plsregress done')

        yhat(kinds==k,:)=[ones(length(find(kinds==k)),1) timematched_features(kinds==k,:)]*beta_cv;
        disp('yhat done')

        pred_obs_corr(:,:,k)=corr(yhat(kinds==k,:), masked_dat.dat(:,kinds==k)');
        disp('pred_obs_corr done')

        diag_corr(k,:)=diag(pred_obs_corr(:,:,k));
        disp('diag_corr done')

    end


    mean_diag_corr = mean(diag_corr); %estimate the average correlation between observed and predicted values

    save([output_directory 'sub-1_pSTS_emonet_late_mean_diag_corr.mat'], 'mean_diag_corr', '-v7.3') %save performance measures for each subject

    save([output_directory 'beta_sub-1_pSTS_emonet_late_mean_diag_corr.mat'], 'b', '-v7.3') %save betas for each subject


%% save out noise ceiling
    save([output_directory 'noise_ceiling_pSTS_emonet_late.mat'], 'mean_diag_corr_resub')

