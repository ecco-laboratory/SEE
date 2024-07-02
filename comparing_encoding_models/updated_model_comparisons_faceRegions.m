%% load up encoding model results
addpath('/home/data/eccolab/Code/NNDb/SEE/outputs/')
dirpath = '/home/data/eccolab/Code/NNDb/SEE/outputs/';
for s=1:20
 

    load(['sub-' num2str(s) '_Amy_emonet_late_mean_diag_corr.mat']); 
    avgcorr_amygdala_EmoNet(s) = mean(mean_diag_corr);

    load(['sub-' num2str(s) '_pSTS_emofan_late_mean_diag_corr.mat']);
    avgcorr_STS_EmoFAN(s) = mean(mean_diag_corr);

    load(['sub-' num2str(s) '_pSTS_emonet_late_mean_diag_corr.mat']);
    avgcorr_STS_EmoNet(s) = mean(mean_diag_corr);

    load(['sub-' num2str(s) '_pSTS_combined_late_mean_diag_corr.mat']);
    avgcorr_STS_combined(s) = mean(mean_diag_corr);

        load([dirpath 'FFA_old/sub-' num2str(s) '_FFA_emonet_late_mean_diag_corr.mat']); 
    avgcorr_FFA_EmoNet(s) = mean(mean_diag_corr);

        load([dirpath 'OFA_old/sub-' num2str(s) '_OFA_emonet_late_mean_diag_corr.mat']); 
    avgcorr_OFA_EmoNet(s) = mean(mean_diag_corr);

    load([dirpath 'FFA_old/sub-' num2str(s) '_FFA_emonet_intermediate_mean_diag_corr.mat']);
    avgcorr_FFA_EmoNet_intermed(s) = mean(mean_diag_corr);

    load([dirpath 'OFA_old/sub-' num2str(s) '_OFA_emonet_intermediate_mean_diag_corr.mat']);
    avgcorr_OFA_EmoNet_intermed(s) = mean(mean_diag_corr);

    load([dirpath 'FFA_old/sub-' num2str(s) '_FFA_emofan_late_mean_diag_corr.mat']);
    avgcorr_FFA_EmoFAN(s) = mean(mean_diag_corr);

    load([dirpath 'OFA_old/sub-' num2str(s) '_OFA_emofan_late_mean_diag_corr.mat']);
    avgcorr_OFA_EmoFAN(s) = mean(mean_diag_corr);

    load([dirpath 'FFA_old/sub-' num2str(s) '_FFA_emofan_intermediate_mean_diag_corr.mat']);
    avgcorr_FFA_EmoFAN_intermed(s) = mean(mean_diag_corr);

    load([dirpath 'OFA_old/sub-' num2str(s) '_OFA_emofan_intermediate_mean_diag_corr.mat']);
    avgcorr_OFA_EmoFAN_intermed(s) = mean(mean_diag_corr);

    load([dirpath 'FFA_old/sub-' num2str(s) '_FFA_combined_late_mean_diag_corr.mat']);
    avgcorr_FFA_combined(s) = mean(mean_diag_corr);

    load([dirpath 'OFA_old/sub-' num2str(s) '_OFA_combined_late_mean_diag_corr.mat']);
    avgcorr_OFA_combined(s) = mean(mean_diag_corr);

    load([dirpath 'FFA_old/sub-' num2str(s) '_FFA_combined_intermediate_mean_diag_corr.mat']);
    avgcorr_FFA_combined_intermed(s) = mean(mean_diag_corr);

    load([dirpath 'OFA_old/sub-' num2str(s) '_OFA_combined_intermediate_mean_diag_corr.mat']);
    avgcorr_OFA_combined_intermed(s) = mean(mean_diag_corr);


end
%% compare to noise ceiling
    load('/home/data/eccolab/Code/NNDb/SEE/outputs/noise_ceilingAmyemonet_late.mat')
    Amy_EmoNet_Percent_Ceiling = avgcorr_amygdala_EmoNet./mean_diag_corr';
    CI_amy_emonet_pc = bootci(10000,@mean,Amy_EmoNet_Percent_Ceiling);


      load('/home/data/eccolab/Code/NNDb/SEE/outputs/OFA_old/noise_ceilingOFAemonet_intermed.mat')
    OFA_emonet_int_Percent_Ceiling = avgcorr_OFA_EmoNet_intermed./mean_diag_corr';
    CI_OFA_emonet_int_pc = bootci(10000,@mean,OFA_emonet_int_Percent_Ceiling);


          load('/home/data/eccolab/Code/NNDb/SEE/outputs/FFA_old/noise_ceilingFFAemonet_intermed.mat')
    FFA_emonet_int_Percent_Ceiling = avgcorr_FFA_EmoNet_intermed./mean_diag_corr';
    CI_FFA_emonet_int_PC = bootci(10000,@mean,FFA_emonet_int_Percent_Ceiling);

    

 %% plot late layers in FFA and OFA
 X_late = [avgcorr_FFA_EmoNet' avgcorr_FFA_EmoFAN' avgcorr_FFA_combined' avgcorr_OFA_EmoNet' avgcorr_OFA_EmoFAN' avgcorr_OFA_combined'];
 barplot_columns(X_late, 'dolines')
 title 'Late Features on FFA and OFA'
 set(gca, 'XTickLabel',{'FFA EmoNet' 'FFA EmoFAN' 'FFA Combined' 'OFA EmoNet' 'OFA EmoFAN' 'OFA Combined'})
 set(gca, 'XLabel',[])
 ylabel 'Prediction-Outcome Correlation'

 %% plot intermediate layers in FFA and OFA
 X_int = [avgcorr_FFA_EmoNet_intermed' avgcorr_FFA_EmoFAN_intermed' avgcorr_FFA_combined_intermed' avgcorr_OFA_EmoNet_intermed' avgcorr_OFA_EmoFAN_intermed' avgcorr_OFA_combined_intermed'];
 barplot_columns(X_int, 'dolines')
 title 'Intermed Features on FFA, OFA'
 set(gca, 'XTickLabel',{'FFA EmoNet' 'FFA EmoFAN' 'FFA Combined' 'OFA EmoNet' 'OFA EmoFAN' 'OFA Combined'})
 set(gca, 'XLabel',[])
 ylabel 'Prediction-Outcome Correlation'

 %% load noise ceilings for FFA and OFA
 FFA_emofan_noiseceiling = load('noise_ceilingFFAemofan_late.mat');
 FFA_emonet_noiseceiling = load('noise_ceilingFFAemonet_late.mat');
 FFA_combined_noiseceiling = load('noise_ceilingFFAcombined_late.mat');
 OFA_emofan_noiseceiling = load('noise_ceilingOFAemofan_late.mat');
 OFA_emonet_noiseceiling = load('noise_ceilingOFAemonet_late.mat');
 OFA_combined_noiseceiling = load('noise_ceilingOFAcombined_late.mat');
 FFA_emofan_intermed_noiseceiling = load('noise_ceilingFFAemofan_intermed.mat');
 FFA_emonet_intermed_noiseceiling = load('noise_ceilingFFAemonet_intermed.mat');
 FFA_combined_intermed_noiseceiling = load('noise_ceilingFFAcombined_intermed.mat');
 OFA_emofan_intermed_noiseceiling = load('noise_ceilingOFAemofan_intermed.mat');
 OFA_emonet_intermed_noiseceiling = load('noise_ceilingOFAemonet_intermed.mat');
 OFA_combined_intermed_noiseceiling = load('noise_ceilingOFAcombined_intermed.mat');
 
%% ANOVA comparing FFA to STS
X_anova = [ avgcorr_STS_EmoFAN' avgcorr_STS_EmoNet' avgcorr_STS_combined' avgcorr_FFA_EmoFAN' avgcorr_FFA_EmoNet' avgcorr_FFA_combined'];
varNames = {'V1', 'V2', 'V3', 'V4', 'V5', 'V6'};
t_STS_v_FFA = array2table(X_anova, 'VariableNames', varNames);
factorNames = {'Region', 'Model'};
region = categorical([1 1 1  2 2 2])';
model = categorical([1 2 3  1 2 3])';
within = table(region, model, 'VariableNames', factorNames);
rm = fitrm(t_STS_v_FFA, 'V1-V6~1', 'WithinDesign',within, 'WithinModel', 'orthogonalcontrasts');
lateAnovaTable = ranova(rm, 'WithinModel', 'Region*Model');
late_Anova_posthocs = multcompare(rm, 'Model','By','Region');

%% ANOVA comparing OFA to STS
X_anova_2 = [avgcorr_STS_EmoFAN' avgcorr_STS_EmoNet' avgcorr_STS_combined' avgcorr_OFA_EmoFAN' avgcorr_OFA_EmoNet' avgcorr_OFA_combined'];
varNames = {'V1', 'V2', 'V3', 'V4', 'V5', 'V6'};
t_STS_v_OFA = array2table(X_anova_2, 'VariableNames', varNames);
factorNames = {'Region', 'Model'};
region = categorical([1 1 1  2 2 2])';
model = categorical([1 2 3  1 2 3])';
within = table(region, model, 'VariableNames', factorNames);
rm_2 = fitrm(t_STS_v_OFA, 'V1-V6~1', 'WithinDesign', within, 'WithinModel','orthogonalcontrasts');
lateAnovaTable_OFA = ranova(rm_2, 'WithinModel', 'Region*Model');
late_Anova_OFA_posthocs = multcompare(rm_2, 'Model','By','Region');




