%% load up encoding model results

for s=1:20
 

    load(['sub-' num2str(s) '_Amy_emonet_late_mean_diag_corr.mat']); 
    avgcorr_amygdala_EmoNet(s) = mean(mean_diag_corr);

        load(['sub-' num2str(s) '_FFA_emonet_late_mean_diag_corr.mat']); 
    avgcorr_FFA_EmoNet(s) = mean(mean_diag_corr);

        load(['sub-' num2str(s) '_OFA_emonet_late_mean_diag_corr.mat']); 
    avgcorr_OFA_EmoNet(s) = mean(mean_diag_corr);

end
%%
    load('/home/data/eccolab/Code/NNDb/SEE/outputs/noise_ceilingAmyemonet_late.mat')
    Amy_EmoNet_Percent_Ceiling = avgcorr_amygdala_EmoNet./mean_diag_corr';
    bootci(10000,@mean,Amy_EmoNet_Percent_Ceiling)


      load('/home/data/eccolab/Code/NNDb/SEE/outputs/noise_ceilingOFAemonet_late.mat')
    OFA_EmoNet_Percent_Ceiling = avgcorr_OFA_EmoNet./mean_diag_corr';
    bootci(10000,@mean,OFA_EmoNet_Percent_Ceiling)


          load('/home/data/eccolab/Code/NNDb/SEE/outputs/noise_ceilingFFAemonet_late.mat')
    FFA_EmoNet_Percent_Ceiling = avgcorr_FFA_EmoNet./mean_diag_corr';
    bootci(10000,@mean,FFA_EmoNet_Percent_Ceiling)