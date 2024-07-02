%% load up encoding model results
addpath('/home/data/eccolab/Code/NNDb/SEE/outputs/lateralization')
dirpath = '/home/data/eccolab/Code/NNDb/SEE/outputs/lateralization';
for s=1:20
    load(['sub-' num2str(s) '_Amy_left_emofan_intermediate_mean_diag_corr.mat']); 
    avgcorr_amygdala_left_EmoFAN_conv(s) = mean(mean_diag_corr);
%     csvwrite("amygdala_emoFAN_int.csv",avgcorr_amygdala_EmoFAN_conv)

    load(['sub-' num2str(s) '_Amy_right_emofan_intermediate_mean_diag_corr.mat']);
    avgcorr_amygdala_right_EmoFAN_conv(s) = mean(mean_diag_corr);

    load(['sub-' num2str(s) '_pSTS_left_emofan_intermediate_mean_diag_corr.mat']); 
    avgcorr_pSTS_left_EmoFAN_conv(s) = mean(mean_diag_corr);
%     csvwrite("pSTS_emoFAN_int.csv", avgcorr_pSTS_EmoFAN_conv)

    load(['sub-' num2str(s) '_pSTS_right_emofan_intermediate_mean_diag_corr.mat']);
    avgcorr_pSTS_right_EmoFAN_conv(s) = mean(mean_diag_corr);

    load(['sub-' num2str(s) '_Amy_left_emonet_intermediate_mean_diag_corr.mat']); 
    avgcorr_amygdala_left_EmoNet_fc7(s) = mean(mean_diag_corr);
%     csvwrite("amygdala_EmoNet_int.csv", avgcorr_amygdala_EmoNet_fc7)

    load(['sub-' num2str(s) '_Amy_right_emonet_intermediate_mean_diag_corr.mat']);
    avgcorr_amygdala_right_EmoNet_fc7(s) = mean(mean_diag_corr);

    load(['sub-' num2str(s) '_pSTS_left_emonet_intermediate_mean_diag_corr.mat']); 
    avgcorr_pSTS_left_EmoNet_fc7(s) = mean(mean_diag_corr);
%     csvwrite("pSTS_EmoNet_int.csv",avgcorr_pSTS_EmoNet_fc7)

    load(['sub-' num2str(s) '_pSTS_right_emonet_intermediate_mean_diag_corr.mat']);
    avgcorr_pSTS_right_EmoNet_fc7(s) = mean(mean_diag_corr);

    load(['sub-' num2str(s) '_Amy_left_emonet_late_mean_diag_corr.mat']); 
    avgcorr_amygdala_left_EmoNet(s) = mean(mean_diag_corr);

    load(['sub-' num2str(s) '_Amy_right_emonet_late_mean_diag_corr.mat']);
    avgcorr_amygdala_right_EmoNet(s) = mean(mean_diag_corr);

    load(['sub-' num2str(s) '_pSTS_left_emonet_late_mean_diag_corr.mat']); 
    avgcorr_pSTS_left_EmoNet(s) = mean(mean_diag_corr);

    load(['sub-' num2str(s) '_pSTS_right_emonet_late_mean_diag_corr.mat']);
    avgcorr_pSTS_right_EmoNet(s) = mean(mean_diag_corr);

    load(['sub-' num2str(s) '_Amy_left_combined_late_mean_diag_corr.mat']); 
    avgcorr_amygdala_left_multi(s) = mean(mean_diag_corr);

    load(['sub-' num2str(s) '_Amy_right_combined_late_mean_diag_corr.mat']);
    avgcorr_amygdala_right_multi(s) = mean(mean_diag_corr);

    load(['sub-' num2str(s) '_pSTS_left_combined_late_mean_diag_corr.mat']); 
    avgcorr_pSTS_left_multi(s) = mean(mean_diag_corr);

    load(['sub-' num2str(s) '_pSTS_right_combined_late_mean_diag_corr.mat']);
    avgcorr_pSTS_right_multi(s) = mean(mean_diag_corr);

    load(['sub-' num2str(s) '_Amy_left_combined_intermediate_mean_diag_corr.mat']); 
    avgcorr_amygdala_left_multi_intermed(s) = mean(mean_diag_corr);

    load(['sub-' num2str(s) '_Amy_right_combined_intermediate_mean_diag_corr.mat']);
    avgcorr_amygdala_right_multi_intermed(s) = mean(mean_diag_corr);
 
    load(['sub-' num2str(s) '_pSTS_left_combined_intermediate_mean_diag_corr.mat']); 
    avgcorr_pSTS_left_multi_intermed(s) = mean(mean_diag_corr);

    load(['sub-' num2str(s) '_pSTS_right_combined_intermediate_mean_diag_corr.mat']);
    avgcorr_pSTS_right_multi_intermed(s) = mean(mean_diag_corr);

    load(['sub-' num2str(s) '_pSTS_left_emofan_late_mean_diag_corr.mat']); 
    avgcorr_pSTS_left_EmoFAN_final(s) = mean(mean_diag_corr);

    load(['sub-' num2str(s) '_pSTS_right_emofan_late_mean_diag_corr.mat']);
    avgcorr_pSTS_right_EmoFAN_final(s) = mean(mean_diag_corr);

    load(['sub-' num2str(s) '_Amy_left_emofan_late_mean_diag_corr.mat']); 
    avgcorr_amygdala_left_EmoFAN_final(s) = mean(mean_diag_corr);

    load(['sub-' num2str(s) '_Amy_right_emofan_late_mean_diag_corr.mat']);
    avgcorr_amygdala_right_EmoFAN_final(s) = mean(mean_diag_corr);


end
% TO DO: copy all of these and have one left, one right
%% compute raw performance and percent noise ceiling for each region/model/side combination for late layers
pSTS_emofan_left_late_raw = mean(avgcorr_pSTS_left_EmoFAN_final);
noise_ceiling_pSTS_emofan_left_late = load('/home/data/eccolab/Code/NNDb/SEE/outputs/lateralization/noise_ceilingpSTSleftemofan_late.mat');
noise_ceiling_pSTS_emofan_left_late_true = noise_ceiling_pSTS_emofan_left_late.mean_diag_corr';
pSTS_emofan_left_late_percent_ceiling = avgcorr_pSTS_left_EmoFAN_final./noise_ceiling_pSTS_emofan_left_late_true;

pSTS_emofan_right_late_raw = mean(avgcorr_pSTS_right_EmoFAN_final);
noise_ceiling_pSTS_emofan_right_late = load('/home/data/eccolab/Code/NNDb/SEE/outputs/lateralization/noise_ceilingpSTSrightemofan_late.mat');
noise_ceiling_pSTS_emofan_right_late_true = noise_ceiling_pSTS_emofan_right_late.mean_diag_corr';
pSTS_emofan_right_late_percent_ceiling = avgcorr_pSTS_right_EmoFAN_final./noise_ceiling_pSTS_emofan_right_late_true;

pSTS_emonet_left_late_raw = mean(avgcorr_pSTS_left_EmoNet);
noise_ceiling_pSTS_emonet_left_late = load('/home/data/eccolab/Code/NNDb/SEE/outputs/lateralization/noise_ceilingpSTSleftemonet_late.mat');
noise_ceiling_pSTS_emonet_left_late_true = noise_ceiling_pSTS_emonet_left_late.mean_diag_corr';
pSTS_emonet_left_late_percent_ceiling = avgcorr_pSTS_left_EmoNet./noise_ceiling_pSTS_emonet_left_late_true;

pSTS_emonet_right_late_raw = mean(avgcorr_pSTS_right_EmoNet);
noise_ceiling_pSTS_emonet_right_late = load('/home/data/eccolab/Code/NNDb/SEE/outputs/lateralization/noise_ceilingpSTSrightemonet_late.mat');
noise_ceiling_pSTS_emonet_right_late_true = noise_ceiling_pSTS_emonet_right_late.mean_diag_corr';
pSTS_emonet_right_late_percent_ceiling = avgcorr_pSTS_right_EmoNet./noise_ceiling_pSTS_emonet_right_late_true;

pSTS_combined_left_late_raw = mean(avgcorr_pSTS_left_multi);
noise_ceiling_pSTS_combined_left_late = load('/home/data/eccolab/Code/NNDb/SEE/outputs/lateralization/noise_ceilingpSTSleftcombined_late.mat');
noise_ceiling_pSTS_combined_left_late_true = noise_ceiling_pSTS_combined_left_late.mean_diag_corr';
pSTS_combined_left_late_percent_ceiling = avgcorr_pSTS_left_multi./noise_ceiling_pSTS_combined_left_late_true;

pSTS_combined_right_late_raw = mean(avgcorr_pSTS_right_multi);
noise_ceiling_pSTS_combined_right_late = load('/home/data/eccolab/Code/NNDb/SEE/outputs/lateralization/noise_ceilingpSTSrightcombined_late.mat');
noise_ceiling_pSTS_combined_right_late_true = noise_ceiling_pSTS_combined_right_late.mean_diag_corr';
pSTS_combined_right_late_percent_ceiling = avgcorr_pSTS_right_multi./noise_ceiling_pSTS_combined_right_late_true;

amygdala_emofan_left_late_raw = mean(avgcorr_amygdala_left_EmoFAN_final);
noise_ceiling_amygdala_emofan_left_late = load('/home/data/eccolab/Code/NNDb/SEE/outputs/lateralization/noise_ceilingAmyleftemofan_late.mat');
noise_ceiling_amygdala_emofan_left_late_true = noise_ceiling_amygdala_emofan_left_late.mean_diag_corr';
amygdala_emofan_left_late_percent_ceiling = avgcorr_amygdala_left_EmoFAN_final./noise_ceiling_amygdala_emofan_left_late_true;

amygdala_emofan_right_late_raw = mean(avgcorr_amygdala_right_EmoFAN_final);
noise_ceiling_amygdala_emofan_right_late = load('/home/data/eccolab/Code/NNDb/SEE/outputs/lateralization/noise_ceilingAmyrightemofan_late.mat');
noise_ceiling_amygdala_emofan_right_late_true = noise_ceiling_amygdala_emofan_right_late.mean_diag_corr';
amygdala_emofan_right_late_percent_ceiling = avgcorr_amygdala_right_EmoFAN_final./noise_ceiling_amygdala_emofan_right_late_true;

amygdala_emonet_left_late_raw = mean(avgcorr_amygdala_left_EmoNet);
noise_ceiling_amygdala_emonet_left_late = load('/home/data/eccolab/Code/NNDb/SEE/outputs/lateralization/noise_ceilingAmyleftemonet_late.mat');
noise_ceiling_amygdala_emonet_left_late_true = noise_ceiling_amygdala_emonet_left_late.mean_diag_corr';
amygdala_emonet_left_late_percent_ceiling = avgcorr_amygdala_left_EmoNet./noise_ceiling_amygdala_emonet_left_late_true;

amygdala_emonet_right_late_raw = mean(avgcorr_amygdala_right_EmoNet);
noise_ceiling_amygdala_emonet_right_late = load('/home/data/eccolab/Code/NNDb/SEE/outputs/lateralization/noise_ceilingAmyrightemonet_late.mat');
noise_ceiling_amygdala_emonet_right_late_true = noise_ceiling_amygdala_emonet_right_late.mean_diag_corr';
amygdala_emonet_right_late_percent_ceiling = avgcorr_amygdala_right_EmoNet./noise_ceiling_amygdala_emonet_right_late_true;

amygdala_combined_left_late_raw = mean(avgcorr_amygdala_left_multi);
noise_ceiling_amygdala_combined_left_late = load('/home/data/eccolab/Code/NNDb/SEE/outputs/lateralization/noise_ceilingAmyleftcombined_late.mat');
noise_ceiling_amygdala_combined_left_late_true = noise_ceiling_amygdala_combined_left_late.mean_diag_corr';
amygdala_combined_left_late_percent_ceiling = avgcorr_amygdala_left_multi./noise_ceiling_amygdala_combined_left_late_true;

amygdala_combined_right_late_raw = mean(avgcorr_amygdala_right_multi);
noise_ceiling_amygdala_combined_right_late = load('/home/data/eccolab/Code/NNDb/SEE/outputs/lateralization/noise_ceilingAmyrightcombined_late.mat');
noise_ceiling_amygdala_combined_right_late_true = noise_ceiling_amygdala_combined_right_late.mean_diag_corr';
amygdala_combined_right_late_percent_ceiling = avgcorr_amygdala_right_multi./noise_ceiling_amygdala_combined_right_late_true;

%% compute raw performance and percent noise ceiling for each region/model/side combination for intermediate layers
pSTS_emofan_left_int_raw = mean(avgcorr_pSTS_left_EmoFAN_conv);
noise_ceiling_pSTS_emofan_left_int = load('/home/data/eccolab/Code/NNDb/SEE/outputs/lateralization/noise_ceilingpSTSleftemofan_intermed.mat');
noise_ceiling_pSTS_emofan_left_int_true = noise_ceiling_pSTS_emofan_left_int.mean_diag_corr';
pSTS_emofan_left_int_percent_ceiling = avgcorr_pSTS_left_EmoFAN_conv./noise_ceiling_pSTS_emofan_left_int_true;

pSTS_emofan_right_int_raw = mean(avgcorr_pSTS_right_EmoFAN_conv);
noise_ceiling_pSTS_emofan_right_int = load('/home/data/eccolab/Code/NNDb/SEE/outputs/lateralization/noise_ceilingpSTSrightemofan_intermed.mat');
noise_ceiling_pSTS_emofan_right_int_true = noise_ceiling_pSTS_emofan_right_int.mean_diag_corr';
pSTS_emofan_right_int_percent_ceiling = avgcorr_pSTS_right_EmoFAN_conv./noise_ceiling_pSTS_emofan_right_int_true;

pSTS_emonet_left_int_raw = mean(avgcorr_pSTS_left_EmoNet_fc7);
noise_ceiling_pSTS_emonet_left_int = load('/home/data/eccolab/Code/NNDb/SEE/outputs/lateralization/noise_ceilingpSTSleftemonet_intermed.mat');
noise_ceiling_pSTS_emonet_left_int_true = noise_ceiling_pSTS_emonet_left_int.mean_diag_corr';
pSTS_emonet_left_int_percent_ceiling = avgcorr_pSTS_left_EmoNet_fc7./noise_ceiling_pSTS_emonet_left_int_true;

pSTS_emonet_right_int_raw = mean(avgcorr_pSTS_right_EmoNet_fc7);
noise_ceiling_pSTS_emonet_right_int = load('/home/data/eccolab/Code/NNDb/SEE/outputs/lateralization/noise_ceilingpSTSrightemonet_intermed.mat');
noise_ceiling_pSTS_emonet_right_int_true = noise_ceiling_pSTS_emonet_right_int.mean_diag_corr';
pSTS_emonet_right_int_percent_ceiling = avgcorr_pSTS_right_EmoNet_fc7./noise_ceiling_pSTS_emonet_right_int_true;

pSTS_combined_left_int_raw = mean(avgcorr_pSTS_left_multi_intermed);
noise_ceiling_pSTS_combined_left_int = load('/home/data/eccolab/Code/NNDb/SEE/outputs/lateralization/noise_ceilingpSTSleftcombined_intermed.mat');
noise_ceiling_pSTS_combined_left_int_true = noise_ceiling_pSTS_combined_left_int.mean_diag_corr';
pSTS_combined_left_int_percent_ceiling = avgcorr_pSTS_left_multi_intermed./noise_ceiling_pSTS_combined_left_int_true;

pSTS_combined_right_int_raw = mean(avgcorr_pSTS_right_multi_intermed);
noise_ceiling_pSTS_combined_right_int = load('/home/data/eccolab/Code/NNDb/SEE/outputs/lateralization/noise_ceilingpSTSrightcombined_intermed.mat');
noise_ceiling_pSTS_combined_right_int_true = noise_ceiling_pSTS_combined_right_int.mean_diag_corr';
pSTS_combined_right_int_percent_ceiling = avgcorr_pSTS_right_multi_intermed./noise_ceiling_pSTS_combined_right_int_true;

amygdala_emofan_left_int_raw = mean(avgcorr_amygdala_left_EmoFAN_conv);
noise_ceiling_amygdala_emofan_left_int = load('/home/data/eccolab/Code/NNDb/SEE/outputs/lateralization/noise_ceilingAmyleftemofan_intermed.mat');
noise_ceiling_amygdala_emofan_left_int_true = noise_ceiling_amygdala_emofan_left_int.mean_diag_corr';
amygdala_emofan_left_int_percent_ceiling = avgcorr_amygdala_left_EmoFAN_conv./noise_ceiling_amygdala_emofan_left_int_true;

amygdala_emofan_right_int_raw = mean(avgcorr_amygdala_right_EmoFAN_conv);
noise_ceiling_amygdala_emofan_right_int = load('/home/data/eccolab/Code/NNDb/SEE/outputs/lateralization/noise_ceilingAmyrightemofan_intermed.mat');
noise_ceiling_amygdala_emofan_right_int_true = noise_ceiling_amygdala_emofan_right_int.mean_diag_corr';
amygdala_emofan_right_int_percent_ceiling = avgcorr_amygdala_right_EmoFAN_conv./noise_ceiling_amygdala_emofan_right_int_true;

amygdala_emonet_left_int_raw = mean(avgcorr_amygdala_left_EmoNet_fc7);
noise_ceiling_amygdala_emonet_left_int = load('/home/data/eccolab/Code/NNDb/SEE/outputs/lateralization/noise_ceilingAmyleftemonet_intermed.mat');
noise_ceiling_amygdala_emonet_left_int_true = noise_ceiling_amygdala_emonet_left_int.mean_diag_corr';
amygdala_emonet_left_int_percent_ceiling = avgcorr_amygdala_left_EmoNet_fc7./noise_ceiling_amygdala_emonet_left_int_true;

amygdala_emonet_right_int_raw = mean(avgcorr_amygdala_right_EmoNet_fc7);
noise_ceiling_amygdala_emonet_right_int = load('/home/data/eccolab/Code/NNDb/SEE/outputs/lateralization/noise_ceilingAmyrightemonet_intermed.mat');
noise_ceiling_amygdala_emonet_right_int_true = noise_ceiling_amygdala_emonet_right_int.mean_diag_corr';
amygdala_emonet_right_int_percent_ceiling = avgcorr_amygdala_right_EmoNet_fc7./noise_ceiling_amygdala_emonet_right_int_true;

amygdala_combined_left_int_raw = mean(avgcorr_amygdala_left_multi_intermed);
noise_ceiling_amygdala_combined_left_int = load('/home/data/eccolab/Code/NNDb/SEE/outputs/lateralization/noise_ceilingAmyleftcombined_intermed.mat');
noise_ceiling_amygdala_combined_left_int_true = noise_ceiling_amygdala_combined_left_int.mean_diag_corr';
amygdala_combined_left_int_percent_ceiling = avgcorr_amygdala_left_multi_intermed./noise_ceiling_amygdala_combined_left_int_true;

amygdala_combined_right_int_raw = mean(avgcorr_amygdala_right_multi_intermed);
noise_ceiling_amygdala_combined_right_int = load('/home/data/eccolab/Code/NNDb/SEE/outputs/lateralization/noise_ceilingAmyrightcombined_intermed.mat');
noise_ceiling_amygdala_combined_right_int_true = noise_ceiling_amygdala_combined_right_int.mean_diag_corr';
amygdala_combined_right_int_percent_ceiling = avgcorr_amygdala_right_multi_intermed./noise_ceiling_amygdala_combined_right_int_true;

%% post-hoc t-tests to compare left vs. right performance for each model and region

[h_emofan_amyg_late,p_emofan_amyg_late,ci_emofan_amyg_late,stats_emofan_amyg_late] = ttest(amygdala_emofan_left_late_percent_ceiling, amygdala_emofan_right_late_percent_ceiling);
[h_emonet_amyg_late,p_emonet_amyg_late,ci_emonet_amyg_late,stats_emonet_amyg_late] = ttest(amygdala_emonet_left_late_percent_ceiling, amygdala_emonet_right_late_percent_ceiling);
[h_combined_amyg_late,p_combined_amyg_late,ci_combined_amyg_late,stats_combined_amyg_late] = ttest(amygdala_combined_left_late_percent_ceiling, amygdala_combined_right_late_percent_ceiling);

[h_emofan_sts_late,p_emofan_sts_late,ci_emofan_sts_late,stats_emofan_sts_late] = ttest(pSTS_emofan_left_late_percent_ceiling, pSTS_emofan_right_late_percent_ceiling);
[h_emonet_sts_late,p_emonet_sts_late,ci_emonet_sts_late,stats_emonet_sts_late] = ttest(pSTS_emonet_left_late_percent_ceiling, pSTS_emonet_right_late_percent_ceiling);
[h_combined_sts_late,p_combined_sts_late,ci_combined_sts_late,stats_combined_sts_late] = ttest(pSTS_combined_left_late_percent_ceiling, pSTS_combined_right_late_percent_ceiling);

[h_emofan_amyg_int,p_emofan_amyg_int,ci_emofan_amyg_int,stats_emofan_amyg_int] = ttest(amygdala_emofan_left_int_percent_ceiling, amygdala_emofan_right_int_percent_ceiling);
[h_emonet_amyg_int,p_emonet_amyg_int,ci_emonet_amyg_int,stats_emonet_amyg_int] = ttest(amygdala_emonet_left_int_percent_ceiling, amygdala_emonet_right_int_percent_ceiling);
[h_combined_amyg_int,p_combined_amyg_int,ci_combined_amyg_int,stats_combined_amyg_int] = ttest(amygdala_combined_left_int_percent_ceiling, amygdala_combined_right_int_percent_ceiling);

[h_emofan_sts_int,p_emofan_sts_int,ci_emofan_sts_int,stats_emofan_sts_int] = ttest(pSTS_emofan_left_int_percent_ceiling, pSTS_emofan_right_int_percent_ceiling);
[h_emonet_sts_int,p_emonet_sts_int,ci_emonet_sts_int,stats_emonet_sts_int] = ttest(pSTS_emonet_left_int_percent_ceiling, pSTS_emonet_right_int_percent_ceiling);
[h_combined_sts_int,p_combined_sts_int,ci_combined_sts_int,stats_combined_sts_int] = ttest(pSTS_combined_left_int_percent_ceiling, pSTS_combined_right_int_percent_ceiling);
