%% load up encoding model results
addpath('/home/data/eccolab/Code/NNDb/SEE/outputs')
dirpath = '/home/data/eccolab/Code/NNDb/SEE/outputs';
for s=1:20
    load(['sub-' num2str(s) '_Amy_emofan_intermediate_mean_diag_corr.mat']); 
    avgcorr_amygdala_EmoFAN_conv(s) = mean(mean_diag_corr);
%     csvwrite("amygdala_emoFAN_int.csv",avgcorr_amygdala_EmoFAN_conv)

    load(['sub-' num2str(s) '_pSTS_emofan_intermediate_mean_diag_corr.mat']); 
    avgcorr_pSTS_EmoFAN_conv(s) = mean(mean_diag_corr);
%     csvwrite("pSTS_emoFAN_int.csv", avgcorr_pSTS_EmoFAN_conv)


    load(['sub-' num2str(s) '_Amy_emonet_intermediate_mean_diag_corr.mat']); 
    avgcorr_amygdala_EmoNet_fc7(s) = mean(mean_diag_corr);
%     csvwrite("amygdala_EmoNet_int.csv", avgcorr_amygdala_EmoNet_fc7)

    load(['sub-' num2str(s) '_pSTS_emonet_intermediate_mean_diag_corr.mat']); 
    avgcorr_pSTS_EmoNet_fc7(s) = mean(mean_diag_corr);
%     csvwrite("pSTS_EmoNet_int.csv",avgcorr_pSTS_EmoNet_fc7)

    load(['sub-' num2str(s) '_Amy_emonet_late_mean_diag_corr.mat']); 
    avgcorr_amygdala_EmoNet(s) = mean(mean_diag_corr);

    load(['sub-' num2str(s) '_pSTS_emonet_late_mean_diag_corr.mat']); 
    avgcorr_pSTS_EmoNet(s) = mean(mean_diag_corr);


    load(['sub-' num2str(s) '_Amy_combined_late_mean_diag_corr.mat']); 
    avgcorr_amygdala_multi(s) = mean(mean_diag_corr);

    load(['sub-' num2str(s) '_pSTS_combined_late_mean_diag_corr.mat']); 
    avgcorr_pSTS_multi(s) = mean(mean_diag_corr);


    load(['sub-' num2str(s) '_Amy_combined_intermediate_mean_diag_corr.mat']); 
    avgcorr_amygdala_multi_intermed(s) = mean(mean_diag_corr);

    load(['sub-' num2str(s) '_pSTS_combined_intermediate_mean_diag_corr.mat']); 
    avgcorr_pSTS_multi_intermed(s) = mean(mean_diag_corr);


    load(['sub-' num2str(s) '_pSTS_emofan_late_mean_diag_corr.mat']); 
    avgcorr_pSTS_EmoFAN_final(s) = mean(mean_diag_corr);

    load(['sub-' num2str(s) '_Amy_emofan_late_mean_diag_corr.mat']); 
    avgcorr_amygdala_EmoFAN_final(s) = mean(mean_diag_corr);


end
%% make summary table with all encoding model results
summary_table = [avgcorr_amygdala_EmoFAN_conv' avgcorr_amygdala_EmoNet_fc7' avgcorr_amygdala_multi_intermed' avgcorr_pSTS_EmoFAN_conv' avgcorr_pSTS_EmoNet_fc7' avgcorr_pSTS_multi_intermed' avgcorr_amygdala_EmoFAN_final' avgcorr_amygdala_EmoNet' avgcorr_amygdala_multi' avgcorr_pSTS_EmoFAN_final' avgcorr_pSTS_EmoNet' avgcorr_pSTS_multi']
%% write table to a csv file
csvwrite('summary.csv', summary_table);