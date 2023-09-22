%This is a script to use IMAGE features extracted by a specified layer of NN (EmoNet) to predict amygdala activity from BOLD data acquired from NNDb
%includes beta (b) extraction = regression coefficients from our encoding models; betas are the mapping between units in the convnet and BOLD response (pattern of beta coefficients that we used to predict amygdala responses with)

addpath(genpath('/home/data/eccolab/Code/GitHub'))
% load('500_days_of_summer_fc8_features.mat')
t=readtable('/home/data/eccolab/Code/GitHub/emonet/emoFAN_NNDB_lastConv_total.txt');
video_imageFeatures = table2array(t);
lendelta = size(video_imageFeatures, 1);

%an array to iterate all the subjects
subjects = {'1' '2' '3' '4' '5' '6' '7' '8' '9' '10' '11' '12' '13' '14' '15' '16' '17' '18' '19' '20'};

%loop through all subjects
for s = 1:length(subjects)
    
    %load BOLD data for each subject
    dat = fmri_data(['/home/data/eccolab/OpenNeuro/ds002837/derivatives/sub-' subjects{s} '/func/sub-' subjects{s} '_task-500daysofsummer_bold_blur_censor.nii.gz']);
    
    %mask BOLD data to isolate amygdala voxels ONLY
    masked_dat = apply_mask(dat,select_atlas_subset(load_atlas('canlab2018'),{'STSvp','STSdp'}));
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
    timematched_features = conv_features(1:size(masked_dat.dat,2),:);
    disp('timematched_features done')

    %UPDATED to extract and save betas
    [~,~,~,~,b] = plsregress(timematched_features,masked_dat.dat',10); % b = regression coefficient (beta)
    disp('beta done')

    kinds = crossvalind('k',length(masked_dat.dat),5);
    disp('kinds done')

    clear yhat pred_obs_corr diag_corr conv_features

    for k=1:5

        [xl,yl,xs,ys,beta_cv,pctvar] = plsregress(timematched_features(kinds~=k,:), masked_dat.dat(:,kinds~=k)', min(10,size(masked_dat.dat,1))); %size(masked_dat.dat,1)=252
        disp('plsregress done')

        yhat(kinds==k,:)=[ones(length(find(kinds==k)),1) timematched_features(kinds==k,:)]*beta_cv;
        disp('yhat done')

        pred_obs_corr(:,:,k)=corr(yhat(kinds==k,:), masked_dat.dat(:,kinds==k)');
        disp('pred_obs_corr done')

        diag_corr(k,:)=diag(pred_obs_corr(:,:,k));
        disp('diag_corr done')  

    end

    mean_diag_corr = mean(diag_corr);
    
    save(['sub-' subjects{s} '_pSTS_EmoFAN_lastConvTotal_imageFeatures_output.mat'], 'mean_diag_corr', '-v7.3')

    %UPDATED
    save(['beta_sub-' subjects{s} '_pSTS_EmoFAN_lastConvTotal_imageFeatures.mat'], 'b', '-v7.3')

end
