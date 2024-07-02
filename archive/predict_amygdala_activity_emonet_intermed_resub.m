%This is a script to use IMAGE features extracted by a specified layer of NN (EmoNet) to predict amygdala activity from BOLD data acquired from NNDb
%includes beta (b) extraction = regression coefficients from our encoding models; betas are the mapping between units in the convnet and BOLD response (pattern of beta coefficients that we used to predict amygdala responses with)

addpath(genpath('/home/data/eccolab/Code/Github/CanlabCore'))
addpath('/home/data/eccolab/Code/GitHub/spm12')
addpath(genpath('/home/data/eccolab/Code/GitHub/Neuroimaging_Pattern_Masks'))
load('/home/data/eccolab/Code/NNDb/500_days_of_summer_fc7_features.mat')
lendelta = size(video_imageFeatures, 1);

%an array to iterate all the subjects
subjects = {'1' '2' '3' '4' '5' '6' '7' '8' '9' '10' '11' '12' '13' '14' '15' '16' '17' '18' '19' '20'};

%loop through all subjects
for s = 1:length(subjects)
    
    %load BOLD data for each subject
    dat = fmri_data(['/home/data/eccolab/OpenNeuro/ds002837/derivatives/sub-' subjects{s} '/func/sub-' subjects{s} '_task-500daysofsummer_bold_blur_censor.nii.gz']);
    
    %mask BOLD data to isolate amygdala voxels ONLY
    masked_dat = apply_mask(dat,select_atlas_subset(load_atlas('canlab2018'),{'Amy'}));
    % masked_dat = apply_mask(dat,select_atlas_subset(load_atlas('glasser'),{'Ctx_V'}));
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
    timematched_features = conv_features(1:size(masked_dat.dat,2),:); %timematched_fetaures = X = ANN activations/abstract visual features of emo categories
    disp('timematched_features done')

    %UPDATED to extract and save betas (makes predictions in other data) (PLS is linear linking of X = ANN activations/abstract visual features of emo categories to Y = observed BOLD activations in amygdala voxels)
    [~,~,~,~,b] = plsregress(timematched_features,masked_dat.dat',20); % b = regression coefficient (beta) (20 = number of dimensions we want to reduce pls model; x to z = 4096 to 20?)
    disp('beta done')

    kinds = crossvalind('k',length(masked_dat.dat),5); %cross-validation below (k-fold = 5) to make sure encoding model's predicted activations (yhat) are valid/correct/correlated with observed BOLD activations (Y) 
    disp('kinds done')

    clear yhat pred_obs_corr diag_corr conv_features

    %for k=1:5 % k-fold cross-validation = 5

        %[xl,yl,xs,ys,beta_cv,pctvar] = plsregress(timematched_features(kinds~=k,:), masked_dat.dat(:,kinds~=k)', min(20,size(masked_dat.dat,1))); %size(masked_dat.dat,1)=252; x to z dimension reduction
        %disp('plsregress done')

        %yhat(kinds==k,:)=[ones(length(find(kinds==k)),1) timematched_features(kinds==k,:)]*beta_cv; %yhat = predicted y = X*beta = predicted activations in ROI
        %disp('yhat done')

        %pred_obs_corr(:,:,k)=corr(yhat(kinds==k,:), masked_dat.dat(:,kinds==k)'); %what is the correlation between predicted amygdala activations (yhat) with observed amygdala activations (Y) by voxels?
        %disp('pred_obs_corr done')

        %diag_corr(k,:)=diag(pred_obs_corr(:,:,k)); %diagonal correlation
        %disp('diag_corr done')  

    %end

    yhat_resub = [ones(length(kinds),1) timematched_features]*b;
    disp('yhat done')

    pred_obs_corr_resub = corr(yhat_resub, masked_dat.dat');
    disp('pred_obs_corr done')

    diag_corr_resub = diag(pred_obs_corr_resub);
    disp('diag_corr done')

    mean_diag_corr(s,:) = mean(diag_corr_resub)
    
    %save(['sub-' subjects{s} '_amygdala_fc8_invert_imageFeatures_output.mat'], 'mean_diag_corr', '-v7.3')

    %UPDATED
    %save(['beta_sub-' subjects{s} '_amygdala_fc8_invert_imageFeatures.mat'], 'b', '-v7.3')

end
save("/home/data/eccolab/Code/NNDb/SEE/amygdala_noise_ceiling_emonet_intermed.mat", 'mean_diag_corr', '-v7.3')