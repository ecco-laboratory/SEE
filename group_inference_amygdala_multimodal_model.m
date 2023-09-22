addpath(genpath('~/Github'))

%%load in data for all subjects in amygdala

betas = zeros(20,30,252) %subject,categories,voxels

subjects = {'1' '2' '3' '4' '5' '6' '7' '8' '9' '10' '11' '12' '13' '14' '15' '16' '17' '18' '19' '20'};

for s=1:20;

    load(['beta_sub-' num2str(s) '_amygdala_multi_invert_imageFeatures.mat'])

    %load BOLD data for each subject
    dat = fmri_data(['/home/data/eccolab/OpenNeuro/ds002837/derivatives/sub-' subjects{s} '/func/sub-' subjects{s} '_task-500daysofsummer_bold_blur_censor.nii.gz']);
    
    masked_dat = apply_mask(dat,select_atlas_subset(load_atlas('canlab2018'),{'Amy'})); %mask for amygdala (252 voxels)

    excluded_voxels(s,:) = masked_dat.removed_voxels; %ADDED: create a variable that evaluates each subject for removed voxels. This will make a matrix of all voxels (1032) in IT across subjects (20) that have any data 

    betas(s,:,excluded_voxels(s,:)==0)=b(2:end,:)

end

included_voxels = any(excluded_voxels==0) %includes voxels in which any subject has data (excluded_voxel==0 means 'not excluded voxel')

betas(betas==0) = NaN;

%%pca for each subject

for s=1:20
[coeff(s,:,:), scores(s,:,:)]=pca(squeeze(betas(s,:,:)));

end

%%do some mass univariate stats for each unit


for u=1:size(betas,2)
    [h p(u,:) ci st(u)] = ttest(squeeze(betas(:,u,included_voxels)));
    tmap(u,:)=st(u).tstat;

end


%%get information about labels

%load ~/netTransfer_20cat.mat
emonet_labels_cell = {'Adoration','Aesthetic Appreciation','Amusement','Anxiety','Awe','Boredom','Confusion','Craving','Disgust','Empathic Pain','Entrancement','Excitement','Fear','Horror','Interest','Joy','Romance','Sadness','Sexual Desire','Surprise'};
emofan_labels_cell = {'Neutral_FAN','Happy_FAN','Sad_FAN','Surprise_FAN','Fear_FAN','Disgust_FAN','Anger_FAN','Contempt_FAN','Valence_FAN','Arousal_FAN'};

labels = [emonet_labels_cell'; emofan_labels_cell'];

%%get data in MNI space and mask to create stats object
dat = fmri_data(['/home/data/eccolab/OpenNeuro/ds002837/derivatives/sub-1/func/sub-1_task-500daysofsummer_bold_blur_censor.nii.gz']);

%mask BOLD data to isolate amygdala voxels ONLY
masked_dat = apply_mask(dat,select_atlas_subset(load_atlas('canlab2018'),{'Amy'}));

%%FDR correction and mapping back to MNI space
for c=1:30
stat_image = statistic_image;
stat_image.volInfo = masked_dat.volInfo;
stat_image.p = p(c,:)';
stat_image.dat = st(c).tstat';
stat_image.dat(~(p(c,:)<FDR(p(c,:),.05)))=nan;
stat_image.removed_voxels = masked_dat.removed_voxels;
stat_image.removed_images = 0;
%orthviews(stat_image);
stat_image.fullpath = strcat(labels{c}, '_amygdala_expression_tmap.nii');
stat_image.write
pause(3)
end
%%

imwrite(stat_image, '/home/data/eccolab/Code/NNDb/groupinf_amygdala_multimodal_stat_image')