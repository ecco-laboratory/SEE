addpath(genpath('~/Github'))

%%load in data for all subjects in amygdala

% performance_amygdala_EmoNet = zeros(20,20,252); %subject,categories,voxels
% performance_amygdala_multi = zeros(20,20,252); %subject,categories,voxels
% performance_amygdala_EmoFAN_final = zeros(20,20,252); %subject,categories,voxels

subjects = {'1' '2' '3' '4' '5' '6' '7' '8' '9' '10' '11' '12' '13' '14' '15' '16' '17' '18' '19' '20'};

load('amygdala_multimodal_ttest_excluded_voxels.mat')

for s=1:20;



    load(['sub-' num2str(s) '_Amy_emonet_late_mean_diag_corr.mat']);
    performance_amygdala_EmoNet(s,excluded_voxels(s,:)==0) = (mean_diag_corr);

    load(['sub-' num2str(s) '_Amy_combined_late_mean_diag_corr.mat']);
    performance_amygdala_multi(s,excluded_voxels(s,:)==0) = (mean_diag_corr);

    load(['sub-' num2str(s) '_Amy_emofan_late_mean_diag_corr.mat']);
    performance_amygdala_EmoFAN_final(s,excluded_voxels(s,:)==0) = (mean_diag_corr);





end

included_voxels = any(excluded_voxels==0); %includes voxels in which any subject has data (excluded_voxel==0 means 'not excluded voxel')
performance_amygdala_EmoNet=performance_amygdala_EmoNet(:,included_voxels==1);
performance_amygdala_EmoFAN_final=performance_amygdala_EmoFAN_final(:,included_voxels==1);
performance_amygdala_multi=performance_amygdala_multi(:,included_voxels==1);

%% do some mass univariate stats for each unit

[h p_EmoNet ci st] = ttest(squeeze(atanh(performance_amygdala_EmoNet)));
tmap_perf_EmoNet=st.tstat;

[h p_EmoFAN ci st] = ttest(squeeze(atanh(performance_amygdala_EmoFAN_final)));
tmap_perf_EmoFAN=st.tstat;

[h p_multi ci st] = ttest(squeeze(atanh(performance_amygdala_multi)));
tmap_perf_multi=st.tstat;

[h p_EmoNet_diff ci st] = ttest(squeeze(atanh(performance_amygdala_EmoNet))-squeeze(atanh(performance_amygdala_EmoFAN_final)));
tmap_perf_EmoNet_diff=st.tstat;

[h p_multi_diff ci st] = ttest(squeeze(atanh(performance_amygdala_multi))-.5*squeeze(atanh(performance_amygdala_EmoNet)),-.5*squeeze(atanh(performance_amygdala_EmoFAN_final)));
tmap_perf_multi_diff=st.tstat;


%%
load('amygdala_multimodal_ttest_stat_image.mat')
masked_dat = stat_image;

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
stat_image.fullpath = ['amygdala_performance_' names{i} '_FDR05.nii'];
stat_image.write;
end

