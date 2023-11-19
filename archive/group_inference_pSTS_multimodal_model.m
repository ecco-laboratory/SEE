%% load in data for all subjects in pSTS

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

end



%% get information about labels

load ~/netTransfer_20cat.mat
emonet_labels = netTransfer.Layers(end).Classes;
emofan_labels = categorical({'Neutral','Happy','Sad','Surprise','Fear','Disgust','Anger','Contempt','Valence','Arousal'});

labels = [emonet_labels; emofan_labels'];

%% get data in MNI space and mask to create stats object
dat = fmri_data(['/home/data/eccolab/OpenNeuro/ds002837/derivatives/sub-1/func/sub-1_task-500daysofsummer_bold_blur_censor.nii.gz']);

%mask BOLD data to isolate amygdala voxels ONLY
masked_dat = apply_mask(dat,select_atlas_subset(load_atlas('canlab2018'),{'STSvp','STSdp'}));

%% TODO - FDR correction and mapping back to MNI space

for c=1:30
stat_image = statistic_image;
stat_image.volInfo = masked_dat.volInfo;
stat_image.p = p(c,:)';
stat_image.dat = st(c).tstat';
stat_image.dat(~(p(c,:)<FDR(p(c,:),.05)))=nan;
stat_image.removed_voxels = masked_dat.removed_voxels;
stat_image.removed_images = 0;
orthviews(stat_image);
pause(3)
end