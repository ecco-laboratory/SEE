%% load in data for all subjects in pSTS
addpath(genpath('/home/data/eccolab/Code/GitHub/'))
for s=1:20;

    load(['beta_sub-' num2str(s) '_pSTS_multi_invert_imageFeatures.mat'])
    betas(s,:,:)=b(2:end,:);

    %TODO change code to work on amygdala output, and identify missing
    %voxels and assign nan values

end


%% pca for each subject

for s=1:20
[coeff(s,:,:), scores(s,:,:)]=pca(squeeze(betas(s,:,:)));

end

%% do some mass univariate stats for each unit


for u=1:size(betas,2)
    [h p(u,:) ci st(u)] = ttest(squeeze(betas(:,u,:)));
    tmap(u,:)=st(u).tstat;
    bmap(u,:) = mean(squeeze(betas(:,u,:)));

end



%% get information about labels

%load ~/netTransfer_20cat.mat
emonet_labels_cell = {'Adoration','Aesthetic Appreciation','Amusement','Anxiety','Awe','Boredom','Confusion','Craving','Disgust','Empathic Pain','Entrancement','Excitement','Fear','Horror','Interest','Joy','Romance','Sadness','Sexual Desire','Surprise'};
emofan_labels_cell = {'Neutral_FAN','Happy_FAN','Sad_FAN','Surprise_FAN','Fear_FAN','Disgust_FAN','Anger_FAN','Contempt_FAN','Valence_FAN','Arousal_FAN'};

labels = [emonet_labels_cell'; emofan_labels_cell'];

%% get data in MNI space and mask to create stats object
dat = fmri_data(['/home/data/eccolab/OpenNeuro/ds002837/derivatives/sub-1/func/sub-1_task-500daysofsummer_bold_blur_censor.nii.gz']);

%mask BOLD data to isolate amygdala voxels ONLY
masked_dat = apply_mask(dat,select_atlas_subset(load_atlas('canlab2018'),{'STSvp','STSdp'}));

%% TODO - FDR correction and mapping back to MNI space

for c=1:30
stat_image = statistic_image;
stat_image.volInfo = masked_dat.volInfo;
stat_image.p = p(c,:)';
stat_image.dat = bmap(c,:)';
if ~isempty(FDR(p(c,:),.05))
    stat_image.dat(~(p(c,:)<FDR(p(c,:),.05)))=nan;
else
    stat_image.dat(1:length(p),1) = nan;
end
stat_image.removed_voxels = masked_dat.removed_voxels;
stat_image.removed_images = 0;
%orthviews(stat_image);
stat_image.fullpath = strcat(labels{c}, '_pSTS_expression_bmap.nii');
stat_image.write
pause(3)
end
%% 

%imwrite(stat_image, '/home/data/eccolab/Code/NNDb/groupinf_pSTS_multimodal')