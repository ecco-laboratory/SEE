addpath(genpath('~/Github'))

%%load in data for all subjects in amygdala

betas = zeros(20,20,252); %subject,categories,voxels

subjects = {'1' '2' '3' '4' '5' '6' '7' '8' '9' '10' '11' '12' '13' '14' '15' '16' '17' '18' '19' '20'};

load('amygdala_multimodal_ttest_excluded_voxels.mat')

for s=1:20;

    load(['beta_sub-' num2str(s) '_amygdala_fc8_invert_imageFeatures.mat'])

    %load BOLD data for each subject
%     dat = fmri_data(['/home/data/eccolab/OpenNeuro/ds002837/derivatives/sub-' subjects{s} '/func/sub-' subjects{s} '_task-500daysofsummer_bold_blur_censor.nii.gz']);
    
%     masked_dat = apply_mask(dat,select_atlas_subset(load_atlas('canlab2018'),{'Amy'})); %mask for amygdala (252 voxels)

%     excluded_voxels(s,:) = masked_dat.removed_voxels; %ADDED: create a variable that evaluates each subject for removed voxels. This will make a matrix of all voxels (1032) in IT across subjects (20) that have any data 

    betas(s,:,excluded_voxels(s,:)==0)=b(2:end,:);

end

included_voxels = any(excluded_voxels==0); %includes voxels in which any subject has data (excluded_voxel==0 means 'not excluded voxel')

betas(betas==0) = NaN;

%% pca for group

for it=1:5000
bs_b= squeeze(nanmean(betas(randsample(20,20,true),:,included_voxels)));
[coeff(it,:,:), score(it,:,:)]=pca(bs_b);
end


mean_bs_coeff = squeeze(mean(coeff));
se_bs_coeff = squeeze(std(coeff));
Z_bs_coeff = mean_bs_coeff./se_bs_coeff;
p_coeff = normcdf(-abs(squeeze(Z_bs_coeff)));



mean_bs_score = squeeze(mean(score));
se_bs_score = squeeze(std(score));
Z_bs_score = mean_bs_score./se_bs_score;
p_score = normcdf(-abs(squeeze(Z_bs_score)));




%% do some mass univariate stats for each unit


for u=1:size(betas,2)
    [h p(u,:) ci st(u)] = ttest(squeeze(betas(:,u,included_voxels)));
    tmap(u,:)=st(u).tstat;

end


%% get information about labels

%load ~/netTransfer_20cat.mat
emonet_labels_cell = {'Adoration','Aesthetic Appreciation','Amusement','Anxiety','Awe','Boredom','Confusion','Craving','Disgust','Empathic Pain','Entrancement','Excitement','Fear','Horror','Interest','Joy','Romance','Sadness','Sexual Desire','Surprise'};

labels = [emonet_labels_cell'];

%%get data in MNI space and mask to create stats object
% dat = fmri_data(['/home/data/eccolab/OpenNeuro/ds002837/derivatives/sub-1/func/sub-1_task-500daysofsummer_bold_blur_censor.nii.gz']);

%mask BOLD data to isolate amygdala voxels ONLY
% masked_dat = apply_mask(dat,select_atlas_subset(load_atlas('canlab2018'),{'Amy'}));
load('amygdala_multimodal_ttest_stat_image.mat')
masked_dat = stat_image;
%%FDR correction and mapping back to MNI space
for c=1:20
stat_image = statistic_image;
stat_image.volInfo = masked_dat.volInfo;
stat_image.p = p(c,:)';
stat_image.dat = st(c).tstat';

stat_image.dat(~(p(c,:)<.05))=nan;
maxval_uncorrected(c)=max(abs(stat_image.dat));

stat_image.removed_voxels = masked_dat.removed_voxels;
stat_image.removed_images = 0;
stat_image.fullpath = strcat(labels{c}, '_amygdala_expression_tmap_uncorrected.nii');
write(stat_image,'overwrite')


if ~isempty(FDR(p(c,:),.05))
stat_image.dat(~(p(c,:)<FDR(p(c,:),.05)))=nan;
else
stat_image.dat(1:length(stat_image.dat),1) = nan;
end

%orthviews(stat_image);
stat_image.fullpath = strcat(labels{c}, '_amygdala_expression_tmap.nii');
write(stat_image,'overwrite')
pause(3)
end

%%

[~,ord]=sort(mean(score(:,:,1)),'descend');
figure; hold on; plot([0 21],[0 0],'k-.')
distributionPlot(squeeze(score(:,ord,1)),'showMM',0); %'colormap',1-gray(64)
set(gca,'XTickLabel',labels(ord));axis tight;
ylabel 'Principal Component Score'

%% Z-maps for first three PCs

for c=1:3
stat_image = statistic_image;
stat_image.volInfo = masked_dat.volInfo;
stat_image.p = p_coeff(:,c);
stat_image.dat = Z_bs_coeff(:,c);
stat_image.dat(~(p_coeff(:,c)<.05))=nan;
stat_image.removed_voxels = masked_dat.removed_voxels;
stat_image.removed_images = 0;
% orthviews(stat_image);
stat_image.fullpath = ['amygdala_expression_PC' num2str(c) '_UNC05.nii'];
stat_image.write
pause(3)
end
