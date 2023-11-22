% Take features extracted by a specified layer of ANN (EmoNet
% or EmoFAN) to predict amygdala activity from BOLD data acquired from
% NNDb.

% note: you will need CanlabCore on your path %addpath(genpath('~/GitHub'))

addpath(genpath('/home/data/eccolab/Code/GitHub/CanlabCore'))
addpath('/home/data/eccolab/Code/GitHub/spm12')
addpath(genpath('/home/data/eccolab/Code/GitHub/Neuroimaging_Pattern_Masks'))
addpath(genpath('/home/data/eccolab/Code/GitHub/emonet'))
%% set up some paths
% note: update these paths with the folder you downloaded
fmri_data_path = '/home/data/eccolab/OpenNeuro/ds002837/derivatives/sub-1/func';


% note: can specify output directory here for saving files
output_directory = '/home/data/eccolab/Code/NNDb/SEE/outputs/';


%% Load extracted features and perform the analysis using the loaded data
load("500_days_of_summer_fc8_features.mat");
t = readtable('/home/data/eccolab/Code/GitHub/emonet/emonet_face_output_NNDB_lastFC.txt');
video_imageFeatures_fan = table2array(t);
lendelta = size(video_imageFeatures, 1);
lendelta_fan = size(video_imageFeatures_fan, 1);
    %load BOLD data for sub 1
    dat = fmri_data([fmri_data_path filesep 'sub-1_task-500daysofsummer_bold_blur_censor.nii.gz']);

    %mask BOLD data to isolate pSTS voxels ONLY

    masked_dat = apply_mask(dat,select_atlas_subset(load_atlas('canlab2018'),{'STSvp','STSdp'}));

    disp('masked_dat done')

    %UPDATED: this line resamples size of imagefeatures (video_imageFeatures) by row (182) to the size of the BOLD data (masked_dat.dat) by column (5470): resample = data resized by p/q: resample(data, p, q)
    features = resample(double(video_imageFeatures),size(masked_dat.dat,2),lendelta);
    features_fan = resample(double(video_imageFeatures_fan),size(masked_dat.dat,2),lendelta_fan);
    disp('resample features done')

    %This loop convolutes the video image features to match time delay of hemodynamic BOLD data
    for i = 1:size(features, 2) %for each column (timeseries) of NN output (...features.mat)

        %assign a corresponding column in a convolved output matrix, after convolving with spm's hrf
        tmp = conv(double(features(:,i)), spm_hrf(1));

        %UPDATED
        %X(:,i) = tmp(1:lendelta);
        conv_features(:,i) = tmp(:);

    end

    % do the same for emofan
    for j = 1:size(features_fan,2)
        tmp2 = conv(double(features_fan(:,j)), spm_hrf(1));
        conv_features_fan(:,j) = tmp2(:);
    end

    %UPDATED(x2): this line matches/cuts the length of conv_features to match with length of BOLD data
    timematched_features = conv_features(1:size(masked_dat.dat,2),:);
    timematched_features_fan = conv_features_fan(1:size(masked_dat.dat,2),:);
    disp('timematched_features done')

    %UPDATED to extract and save betas
    [~,~,~,~,b] = plsregress(timematched_features,masked_dat.dat',20); % b = regression coefficient (beta)
    [~,~,~,~,b_fan] = plsregress(timematched_features_fan, masked_dat.dat',10);
    disp('beta done')


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

    for k=1:5
        [~,~,~,~,beta_cv_fan] = plsregress(timematched_features_fan(kinds~=k,:), masked_dat.dat(:,kinds~=k)', min(10, size(masked_dat.dat,1)));
        yhat_fan(kinds==k,:)=[ones(length(find(kinds==k)),1) timematched_features_fan(kinds==k,:)]*beta_cv_fan;
        pred_obs_corr_fan(:,:,k)=corr(yhat_fan(kinds==k,:), masked_dat.dat(:,kinds==k)');
        diag_corr_fan(k,:)=diag(pred_obs_corr_fan(:,:,k));

    end
    mean_diag_corr = mean(diag_corr); %estimate the average correlation between observed and predicted values

    mean_diag_corr_fan = mean(diag_corr_fan);

    save([output_directory 'sub-1_pSTS_emonet_late_mean_diag_corr.mat'], 'mean_diag_corr', '-v7.3') %save performance measures for each subject

    save([output_directory, 'sub-1_pSTS_emofan_late_mean_diag_corr.mat'], 'mean_diag_corr_fan', '-v7.3')

    save([output_directory 'beta_sub-1_pSTS_emonet_late_mean_diag_corr.mat'], 'b', '-v7.3') %save betas for each subject

       save([output_directory 'beta_sub-1_pSTS_emofan_late_mean_diag_corr.mat'], 'b_fan', '-v7.3')
