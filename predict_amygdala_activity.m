%This is a script that uses features extracted by a specified layer of ANN (EmoNet or EmoFAN) to predict amygdala activity from BOLD data acquired from NNDb
function predict_amygdala(model,layer)
    addpath(genpath('~/GitHub'))
    if model == 'emonet'
        if layer == 'late'
            video_imageFeatures = load(/PATH/'500_days_of_summer_fc8_features.mat');
            keyword = 'emonet_late'
        elseif layer == 'intermediate'
            video_imageFeatures = load(/PATH/'500_days_of_summer_fc7_features.mat');
            keyword = 'emonet_intermediate'
        end
    elseif model == 'emofan'
        if layer == 'late'
            t=readtable(PATH/'emonet_face_output_NNDB_lastFC.txt')
            video_imageFeatures = table2array(t);
            keyword = 'emofan_late'
        elseif layer == 'intermediate'
            t=readtable('/home/data/eccolab/Code/GitHub/emonet/emoFAN_NNDB_lastConv_total.txt');
            video_imageFeatures = table2array(t);
            keyword = 'emofan_intermediate'
        end
    elseif model == 'combined'
        if layer == 'late'
            t=readtable(PATH/'emonet_face_output_NNDB_lastFC.txt');
            video_imageFeatures_fan = table2arrray(t);
            video_imageFeatures_net = load(PATH/'500_days_of_summer_fc8_features.mat');
            keyword = 'combined_late'
        elseif layer == 'intermediate'
            t=readtable(PATH/'emoFAN_NNDB_lastConv_total.txt');
            video_imageFeatures_fan = table2array(t);
            video_imageFeatures_net = load(PATH/'500_days_of_summer_fc7_features.mat');
            keyword = 'combined_intermediate'
        end
    else
        disp('The inputs you have provided are invalid. Possible inputs for "model" are "emonet", "emofan", and "combined". Possible inputs for "layer" are "late" and "intermediate".')
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
        
        save(['sub-' subjects{s} keyword 'amygdala_prediction.mat'], 'mean_diag_corr', '-v7.3')
    
        %UPDATED
        save(['beta_sub-' subjects{s} keyword '_amygdala_prediction.mat'], 'b', '-v7.3')
    
    end
end
