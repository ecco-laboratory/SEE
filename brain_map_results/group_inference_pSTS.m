%% load in data for all subjects in pSTS
addpath(genpath('/home/data/eccolab/Code/GitHub/'))
for s=1:20;


    load(['sub-' num2str(s) '_pSTS_emonet_late_mean_diag_corr.mat']);
    performance_pSTS_EmoNet(s,:) = (mean_diag_corr);


    load(['sub-' num2str(s) '_pSTS_combined_late_mean_diag_corr.mat']);
    performance_pSTS_multi(s,:) = (mean_diag_corr);


    load(['sub-' num2str(s) '_pSTS_emofan_late_mean_diag_corr.mat']);
    performance_pSTS_EmoFAN(s,:) = (mean_diag_corr);

 

end

%% do some mass univariate stats for each unit

[h p_EmoNet ci st] = ttest(squeeze(atanh(performance_pSTS_EmoNet)));
tmap_perf_EmoNet=st.tstat;

[h p_EmoFAN ci st] = ttest(squeeze(atanh(performance_pSTS_EmoFAN)));
tmap_perf_EmoFAN=st.tstat;

[h p_multi ci st] = ttest(squeeze(atanh(performance_pSTS_multi)));
tmap_perf_multi=st.tstat;

[h p_EmoNet_diff ci st] = ttest(squeeze(atanh(performance_pSTS_EmoNet))-squeeze(atanh(performance_pSTS_EmoFAN)));
tmap_perf_EmoNet_diff=st.tstat;

[h p_multi_diff ci st] = ttest(squeeze(atanh(performance_pSTS_multi))-.5*squeeze(atanh(performance_pSTS_EmoNet)),-.5*squeeze(atanh(performance_pSTS_EmoFAN)));
tmap_perf_multi_diff=st.tstat;



%% get data in MNI space and mask to create stats object
dat = fmri_data('/home/data/eccolab/OpenNeuro/ds002837/derivatives/sub-1/func/sub-1_task-500daysofsummer_bold_blur_censor.nii,1');

%mask BOLD data to isolate pSTS voxels ONLY
masked_dat = apply_mask(dat,select_atlas_subset(load_atlas('canlab2018'),{'STSvp','STSdp'}));


%% tmap on model performance

tmaps=[tmap_perf_EmoFAN' tmap_perf_EmoNet' tmap_perf_multi' tmap_perf_EmoNet_diff' tmap_perf_multi_diff'];
pmaps =[p_EmoFAN' p_EmoNet' p_multi' p_EmoNet_diff' p_multi_diff'];
names = {'EmoFAN' 'EmoNet' 'Multi' 'EmoNet_vs_EmoFAN' 'Multi_vs_Single'};


for i=1:size(tmaps,2)
stat_image = statistic_image;
stat_image.volInfo = masked_dat.volInfo;
stat_image.p = pmaps(:,i);          
stat_image.dat = tmaps(:,i);
stat_image.dat(~(pmaps(:,i)<FDR(pmaps(:,i),.05)))=nan;
stat_image.removed_voxels = masked_dat.removed_voxels;
stat_image.removed_images = 0;
stat_image.fullpath = ['pSTS_performance_' names{i} '_FDR05.nii'];
stat_image.write;
end


