for s=1:20
    %load(['sub-' num2str(s) '_amygdala_EmoFAN_lastConv_invert_imageFeatures_output.mat']); 
    %avgcorr_amygdala(s) = mean(mean_diag_corr);

        load(['sub-' num2str(s) '_STS_emonet_fc8_invert_imageFeatures_output.mat']); 
    avgcorr_pSTS(s) = mean(mean_diag_corr);

end