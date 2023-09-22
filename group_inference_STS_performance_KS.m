%%
addpath(genpath('/home/data/eccolab/Code/GitHub/'))
%% 
%%load in data for all subjects in amygdala

% performance_amygdala_EmoNet = zeros(20,20,252); %subject,categories,voxels
% performance_amygdala_multi = zeros(20,20,252); %subject,categories,voxels
% performance_amygdala_EmoFAN_final = zeros(20,20,252); %subject,categories,voxels

subjects = {'1' '2' '3' '4' '5' '6' '7' '8' '9' '10' '11' '12' '13' '14' '15' '16' '17' '18' '19' '20'};

%load('amygdala_multimodal_ttest_excluded_voxels.mat')

for s=1:20



    load(['sub-' num2str(s) '_STS_emonet_fc8_invert_imageFeatures_output.mat']);
    performance_STS_EmoNet(s,:) = (mean_diag_corr);


    load(['sub-' num2str(s) '_pSTS_multi_invert_imageFeatures_output.mat']);
    performance_STS_multi(s,:) = (mean_diag_corr);

    load(['sub-' num2str(s) '_pSTS_EmoFAN_lastFC_invert_imageFeatures_output.mat']);
    performance_STS_EmoFAN_final(s,:) = (mean_diag_corr);




    %load BOLD data for each subject
%     dat = fmri_data(['/home/data/eccolab/OpenNeuro/ds002837/derivatives/sub-' subjects{s} '/func/sub-' subjects{s} '_task-500daysofsummer_bold_blur_censor.nii.gz']);
    
%     masked_dat = apply_mask(dat,select_atlas_subset(load_atlas('canlab2018'),{'Amy'})); %mask for amygdala (252 voxels)



end

%included_voxels = any(excluded_voxels==0); %includes voxels in which any subject has data (excluded_voxel==0 means 'not excluded voxel')
%performance_amygdala_EmoNet=performance_amygdala_EmoNet(:,included_voxels==1);
%performance_amygdala_EmoFAN_final=performance_amygdala_EmoFAN_final(:,included_voxels==1);
%performance_amygdala_multi=performance_amygdala_multi(:,included_voxels==1);

%% do some mass univariate stats for each unit

[h p_EmoNet ci st] = ttest(squeeze(atanh(performance_STS_EmoNet)));
tmap_perf_EmoNet=st.tstat;

[h p_EmoFAN ci st] = ttest(squeeze(atanh(performance_STS_EmoFAN_final)));
tmap_perf_EmoFAN=st.tstat;

[h p_multi ci st] = ttest(squeeze(atanh(performance_STS_multi)));
tmap_perf_multi=st.tstat;

[h p_EmoNet_diff ci st] = ttest(squeeze(atanh(performance_STS_EmoNet))-squeeze(atanh(performance_STS_EmoFAN_final)));
tmap_perf_EmoNet_diff=st.tstat;

[h p_multi_diff ci st] = ttest(squeeze(atanh(performance_STS_multi))-.5*squeeze(atanh(performance_STS_EmoNet)),-.5*squeeze(atanh(performance_STS_EmoFAN_final)));
tmap_perf_multi_diff=st.tstat;


%%
dat = fmri_data(['/home/data/eccolab/OpenNeuro/ds002837/derivatives/sub-1/func/sub-1_task-500daysofsummer_bold_blur_censor.nii,1'])
masked_dat = apply_mask(dat, select_atlas_subset(load_atlas('canlab2018'),{'STSvp','STSdp'}));

%% load tmap to get table of voxels for emofan, STS
emofan_STS_fmridat = fmri_data(['/home/data/eccolab/Code/NNDb/STS_performance_EmoFAN_FDR05.nii'])
emofan_STS_table = table(region(emofan_STS_fmridat))

%% load tmap to get table of voxels for emonet, STS
emonet_STS_fmridat = fmri_data(['/home/data/eccolab/Code/NNDb/STS_performance_EmoNet_FDR05.nii'])
emonet_STS_table = table(region(emonet_STS_fmridat))

%% load tmap to get table of voxels for multi vs single, STS
multi_vs_single_STS_fmridat = fmri_data(['/home/data/eccolab/Code/NNDb/STS_performance_Multi_vs_Single_FDR05.nii'])
multi_vs_single_STS_table = table(region(multi_vs_single_STS_fmridat))

%% load tmap to get table of voxels for emonet, amygdala
emonet_amygdala_fmridat = fmri_data(['/home/data/eccolab/Code/NNDb/performance_maps/amygdala_performance_EmoNet_FDR05.nii'])
emonet_amygdala_table = table(region(emonet_amygdala_fmridat))

%% load tmap to get table of voxels for emonet > emofan, amygdala
emonet_vs_emofan_amygdala_fmridat = fmri_data(['/home/data/eccolab/Code/NNDb/performance_maps/amygdala_performance_EmoNet_vs_EmoFAN_FDR05.nii'])
emonet_vs_emofan_amygdala_table = table(region(emonet_vs_emofan_amygdala_fmridat))

%% tmap on model performance

tmaps=[tmap_perf_EmoFAN' tmap_perf_EmoNet' tmap_perf_multi' tmap_perf_EmoNet_diff' tmap_perf_multi_diff'];
pmaps =[p_EmoFAN' p_EmoNet' p_multi' p_EmoNet_diff' p_multi_diff'];
names = {'EmoFAN' 'EmoNet' 'Multi' 'EmoNet_vs_EmoFAN' 'Multi_vs_Single'};


%for i=1:size(tmaps,2)
stat_image = statistic_image;
stat_image.volInfo = masked_dat.volInfo;
stat_image.p = pmaps(:,1);          
stat_image.dat = tmaps(:,1);
stat_image.dat(~(pmaps(:,1)<FDR(pmaps(:,1),.05)))=nan;
%stat_image.removed_voxels = masked_dat.removed_voxels;
%stat_image.removed_images = 0;
%%
emoFAN_table = table(region(convert2mask(stat_image)));
%stat_image.fullpath = ['STS_performance_' names{i} '_FDR05.nii'];
%stat_image.write;
%end

%%
emoFAN_table = table(region(tmap_perf_EmoFAN));
%%
emonet_table = table(region(tmap_perf_EmoNet));