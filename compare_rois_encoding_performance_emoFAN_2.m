for s=1:20
    load(['sub-' num2str(s) '_pSTS_EmoFAN_lastConvTotal_imageFeatures_output.mat']); 
    avgcorr_pSTS_emoFAN_conv123(s) = mean(mean_diag_corr);

    load(['sub-' num2str(s) '_STS_emonet_fc7_invert_imageFeatures_output.mat']); 
    avgcorr_pSTS_emonet_fc7(s) = mean(mean_diag_corr);

X = [ avgcorr_pSTS_emoFAN_conv123' avgcorr_pSTS_emonet_fc7'];


plotYo = barplot_columns(X,'dolines');
set(gca,'XTickLabel',{ 'pSTS EmoFAN LastConv123' 'pSTS Emonet fc7'})
set(gca,'Xlabel',[])
ylabel 'Prediction-Outcome Correlation'   

saveas(plotYo, 'emoFANlastConv_vs_emonetfc7')
end
