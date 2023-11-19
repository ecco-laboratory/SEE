%% load in data for all subjects in pSTS
addpath(genpath('/home/data/eccolab/Code/GitHub/'))
for s=1:20;
    load(['sub-' num2str(s) '_pSTS_multi_invert_imageFeatures_output.mat'])
    load(['beta_sub-' num2str(s) '_pSTS_multi_invert_imageFeatures.mat'])
    betas(s,:,:)=b(2:end,:);
    performance(s,:)=mean_diag_corr;

    %TODO change code to work on amygdala output, and identify missing
    %voxels and assign nan values

end

%% xval
pca_loocv(betas)

%% pca for group

for it=1:5000
bs_b= squeeze(nanmean(betas(randsample(20,20,true),:,:)));
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
    [h p(u,:) ci st(u)] = ttest(squeeze(betas(:,u,:)));
    
    tmap(u,:)=st(u).tstat;

end

    [h p ci st] = ttest(squeeze(atanh(performance)));
    tmap_perf=st.tstat;

%% get information about labels

%load ~/netTransfer_20cat.mat
emonet_labels_cell = {'Adoration','Aesthetic Appreciation','Amusement','Anxiety','Awe','Boredom','Confusion','Craving','Disgust','Empathic Pain','Entrancement','Excitement','Fear','Horror','Interest','Joy','Romance','Sadness','Sexual Desire','Surprise'};
emofan_labels_cell = {'Neutral Face','Happy Face','Sad Face','Surprise Face','Fear Face','Disgust Face','Anger Face','Contempt Face','Valence Face','Arousal Face'};

labels = [emonet_labels_cell'; emofan_labels_cell'];


%%

[~,ord]=sort(mean(score(:,:,1)),'descend');
figure; hold on; plot([0 31],[0 0],'k-.')
distributionPlot(squeeze(score(:,ord,1)),'showMM',0); %'colormap',1-gray(64)
set(gca,'XTickLabel',labels(ord));axis tight;
ylabel 'Principal Component Score'
%% get data in MNI space and mask to create stats object
dat = fmri_data(['/home/data/eccolab/OpenNeuro/ds002837/derivatives/sub-1/func/sub-1_task-500daysofsummer_bold_blur_censor.nii,1']);

%mask BOLD data to isolate amygdala voxels ONLY
masked_dat = apply_mask(dat,select_atlas_subset(load_atlas('canlab2018'),{'STSvp','STSdp'}));


%% tmap on model performance
stat_image = statistic_image;
stat_image.volInfo = masked_dat.volInfo;
stat_image.p = p';
stat_image.dat = tmap_perf';
stat_image.dat(~(p<FDR(p,.05)))=nan;
stat_image.removed_voxels = masked_dat.removed_voxels;
stat_image.removed_images = 0;
stat_image.fullpath = ['pSTS_expression_PC' num2str(c) '_UNC05.nii'];
pause(3)




%% Z-maps for first three PCs

for c=1%:3
stat_image = statistic_image;
stat_image.volInfo = masked_dat.volInfo;
stat_image.p = p_coeff(:,c);
stat_image.dat = Z_bs_coeff(:,c);
stat_image.dat(~(p_coeff(:,c)<.05))=nan;
stat_image.removed_voxels = masked_dat.removed_voxels;
stat_image.removed_images = 0;
% orthviews(stat_image);
stat_image.fullpath = ['pSTS_expression_PC' num2str(c) '_UNC05.nii'];
% stat_image.write
pause(3)
end
