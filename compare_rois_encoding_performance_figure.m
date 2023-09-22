%% load up encoding model results
addpath(genpath('/home/data/eccolab/Code/GitHub/'))
for s=1:20
    load(['sub-' num2str(s) '_amygdala_EmoFAN_totalConv_imageFeatures_output.mat']); 
    avgcorr_amygdala_EmoFAN_conv(s) = mean(mean_diag_corr);
%     csvwrite("amygdala_emoFAN_int.csv",avgcorr_amygdala_EmoFAN_conv)

    load(['sub-' num2str(s) '_pSTS_EmoFAN_lastConvTotal_imageFeatures_output.mat']); 
    avgcorr_pSTS_EmoFAN_conv(s) = mean(mean_diag_corr);
%     csvwrite("pSTS_emoFAN_int.csv", avgcorr_pSTS_EmoFAN_conv)


    load(['sub-' num2str(s) '_amygdala_fc7_invert_imageFeatures_output.mat']); 
    avgcorr_amygdala_EmoNet_fc7(s) = mean(mean_diag_corr);
%     csvwrite("amygdala_EmoNet_int.csv", avgcorr_amygdala_EmoNet_fc7)

    load(['sub-' num2str(s) '_STS_emonet_fc7_invert_imageFeatures_output.mat']); 
    avgcorr_pSTS_EmoNet_fc7(s) = mean(mean_diag_corr);
%     csvwrite("pSTS_EmoNet_int.csv",avgcorr_pSTS_EmoNet_fc7)

    load(['sub-' num2str(s) '_amygdala_fc8_invert_imageFeatures_output.mat']); 
    avgcorr_amygdala_EmoNet(s) = mean(mean_diag_corr);

    load(['sub-' num2str(s) '_STS_emonet_fc8_invert_imageFeatures_output.mat']); 
    avgcorr_pSTS_EmoNet(s) = mean(mean_diag_corr);


    load(['sub-' num2str(s) '_amygdala_multi_invert_imageFeatures_output.mat']); 
    avgcorr_amygdala_multi(s) = mean(mean_diag_corr);

    load(['sub-' num2str(s) '_pSTS_multi_invert_imageFeatures_output.mat']); 
    avgcorr_pSTS_multi(s) = mean(mean_diag_corr);


    load(['sub-' num2str(s) '_amygdala_multi_intermed_imageFeatures_output.mat']); 
    avgcorr_amygdala_multi_intermed(s) = mean(mean_diag_corr);

    load(['sub-' num2str(s) '_pSTS_multi_intermed_imageFeatures_output.mat']); 
    avgcorr_pSTS_multi_intermed(s) = mean(mean_diag_corr);


    load(['sub-' num2str(s) '_pSTS_EmoFAN_lastFC_invert_imageFeatures_output.mat']); 
    avgcorr_pSTS_EmoFAN_final(s) = mean(mean_diag_corr);

    load(['sub-' num2str(s) '_amygdala_EmoFAN_lastFC_invert_imageFeatures_output.mat']); 
    avgcorr_amygdala_EmoFAN_final(s) = mean(mean_diag_corr);


end
%%
%colnames = ['amygdala_emoFAN_late' 'amygdala_emoNet_late' 'amygdala_multi_late' 'pSTS_emoFAN_late' 'pSTS_emoNet_late' 'pSTS_multi_late' 
    %'amygdala_emoFAN_int' 'amygdala_emoNet_int' 'amygdala_multi_int' 'pSTS_emoFAN_int' 'pSTS_emoNet_int' 'pSTS_multi_int']
X_all = [avgcorr_amygdala_EmoFAN_final' avgcorr_amygdala_EmoNet' avgcorr_amygdala_multi' avgcorr_pSTS_EmoFAN_final' avgcorr_pSTS_EmoNet' avgcorr_pSTS_multi' avgcorr_amygdala_EmoFAN_conv' avgcorr_amygdala_EmoNet_fc7' avgcorr_amygdala_multi_intermed' avgcorr_pSTS_EmoFAN_conv' avgcorr_pSTS_EmoNet_fc7' avgcorr_pSTS_multi_intermed']
% csvwrite("avgcorr_all_conditions.csv", X_all)
%% performance of final fully connected layers
X_late = [ avgcorr_amygdala_EmoFAN_final' avgcorr_amygdala_EmoNet' avgcorr_amygdala_multi' avgcorr_pSTS_EmoFAN_final' avgcorr_pSTS_EmoNet'  avgcorr_pSTS_multi'];




%% performance of intermediate layers (convolutional layer/fc7)
X_int = [ avgcorr_amygdala_EmoFAN_conv' avgcorr_amygdala_EmoNet_fc7' avgcorr_amygdala_multi_intermed' avgcorr_pSTS_EmoFAN_conv' avgcorr_pSTS_EmoNet_fc7'  avgcorr_pSTS_multi_intermed'];




%%
figure;
cb = [.635 .078 .184; .466 .674 .188; .301 .745 .933];
varNames = {'Amygdala Intermediate' 'Amygdala Late' 'pSTS Intermediate'  'pSTS Late'};
X_full = atanh([X_int(:,1:3) X_late(:,1:3) X_int(:,4:6) X_late(:,4:6)]);

cm=0;
for m=[4]
    cm=cm+1;
    %subplot(1,4,cm)
    d{1}=X_full(:,m); d{2}=X_full(:,m+1);d{3}=X_full(:,m+2);

    h1 = raincloud_plot(d{1}, 'box_on', 1, 'color', cb(1,:), 'alpha', 0.5,...
        'box_dodge', 1, 'box_dodge_amount', .15, 'dot_dodge_amount', .35,...
        'box_col_match', 1);
    h2 = raincloud_plot(d{2}, 'box_on', 1, 'color', cb(2,:), 'alpha', 0.5,...
        'box_dodge', 1, 'box_dodge_amount', .55, 'dot_dodge_amount', .75,...
        'box_col_match', 1);
        h3 = raincloud_plot(d{3}, 'box_on', 1, 'color', cb(3,:), 'alpha', 0.5,...
        'box_dodge', 1, 'box_dodge_amount', .95, 'dot_dodge_amount', 1.15,...
        'box_col_match', 1);
    box off
    xlabel(['Model Performance'])
    title(varNames{2})
    % save
%     view([90 -90]);
%     axis ij
    axis tight

end
    legend([h1{1} h2{1} h3{1}], {'Face', 'Context' 'Combined'});
