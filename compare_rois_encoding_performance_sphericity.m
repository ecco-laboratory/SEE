%% load up encoding model results

for s=1:20
    load(['sub-' num2str(s) '_amygdala_EmoFAN_totalConv_imageFeatures_output.mat']); 
    avgcorr_amygdala_EmoFAN_conv(s) = mean(mean_diag_corr);


    load(['sub-' num2str(s) '_pSTS_EmoFAN_lastConvTotal_imageFeatures_output.mat']); 
    avgcorr_pSTS_EmoFAN_conv(s) = mean(mean_diag_corr);
    


    load(['sub-' num2str(s) '_amygdala_fc7_invert_imageFeatures_output.mat']); 
    avgcorr_amygdala_EmoNet_fc7(s) = mean(mean_diag_corr);

    load(['sub-' num2str(s) '_STS_emonet_fc7_invert_imageFeatures_output.mat']); 
    avgcorr_pSTS_EmoNet_fc7(s) = mean(mean_diag_corr);


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

%% performance of final fully connected layers
X_late = [ avgcorr_amygdala_EmoFAN_final' avgcorr_amygdala_EmoNet' avgcorr_amygdala_multi' avgcorr_pSTS_EmoFAN_final' avgcorr_pSTS_EmoNet'  avgcorr_pSTS_multi'];


barplot_columns(X_late,'dolines')
title 'Late Features'
set(gca,'XTickLabel',{'Amygdala EmoFAN' 'Amygdala EmoNet'  'Amygdala Multi' 'pSTS EmoFAN' 'pSTS EmoNet' 'pSTS Multi'})
set(gca,'Xlabel',[])
ylabel 'Prediction-Outcome Correlation'

%% performance of intermediate layers (convolutional layer/fc7)
X_int = [ avgcorr_amygdala_EmoFAN_conv' avgcorr_amygdala_EmoNet_fc7' avgcorr_amygdala_multi_intermed' avgcorr_pSTS_EmoFAN_conv' avgcorr_pSTS_EmoNet_fc7'  avgcorr_pSTS_multi_intermed'];

barplot_columns(X_int,'dolines')
title 'Intermediate Features'
set(gca,'XTickLabel',{'Amygdala EmoFAN' 'Amygdala EmoNet'  'Amygdala Multi' 'pSTS EmoFAN' 'pSTS EmoNet' 'pSTS Multi'})
set(gca,'Xlabel',[])
ylabel 'Prediction-Outcome Correlation'


%% repeated measures anova with ROI, depth, and model as factors (2 by 2 by 3)

% varNames = {'Amygdala_EmoFAN_Int' 'Amygdala_EmoNet_Int'  'Amygdala_Multi_Int' 'pSTS_EmoFAN_Int' 'pSTS_EmoNet_Int'  'pSTS_Multi_Int'  'Amygdala_EmoFAN_Late' 'Amygdala_EmoNet_Late'  'Amygdala_Multi_Late' 'pSTS_EmoFAN_Late' 'pSTS_EmoNet_Late'  'pSTS_Multi_Late'};
for v=1:12
    varNames{v}=['V' num2str(v)];
end

X_full = atanh([X_int X_late]);

t_encoding_performance = array2table(X_full, 'VariableNames',varNames);

factorNames = {'Region','Depth', 'Model'};
region = categorical([1 1 1 2 2 2 1 1 1 2 2 2])';
depth = categorical([1 1 1 1 1 1 2 2 2 2 2 2])';
model = categorical([1 2 3 1 2 3 1 2 3 1 2 3])';

within = table(region, depth, model, 'VariableNames', factorNames);

rm = fitrm(t_encoding_performance,'V1-V12~1','WithinDesign',within);
prediction = rm.predict(t_encoding_performance)
ranovatbl = ranova(rm, 'WithinModel','Region*Depth*Model')

%%
sphericity = mauchly(rm)

%%
epsilonTest = epsilon(rm)
%% Amygdala only model
clear varNames
for v=1:6
    varNames{v}=['V' num2str(v)];
end

X_full = atanh([X_int(:,1:3) X_late(:,1:3)]);

t_encoding_performance = array2table(X_full, 'VariableNames',varNames);

factorNames = {'Depth', 'Model'};
depth = categorical([1 1 1  2 2 2])';
model = categorical([1 2 3  1 2 3])';

within = table(depth, model, 'VariableNames', factorNames);

rm = fitrm(t_encoding_performance,'V1-V6~1','WithinDesign',within);

[ranovatblb] = ranova(rm, 'WithinModel','Depth*Model')

Mrm2 = multcompare(rm,'Model','By','Depth','ComparisonType','dunn-sidak')

%% pSTS only model
clear varNames
for v=1:6
    varNames{v}=['V' num2str(v)];
end

X_full = atanh([X_int(:,4:6) X_late(:,4:6)]);

t_encoding_performance = array2table(X_full, 'VariableNames',varNames);

factorNames = {'Depth', 'Model'};
depth = categorical([1 1 1  2 2 2])';
model = categorical([1 2 3  1 2 3])';

within = table(depth, model, 'VariableNames', factorNames);

rm = fitrm(t_encoding_performance,'V1-V6~1','WithinDesign',within);
rm.predict(t_encoding_performance)

[ranovatblb] = ranova(rm, 'WithinModel','Depth*Model')

Mrm2 = multcompare(rm,'Model','By','Depth','ComparisonType','dunn-sidak')