% load encoding performance for each model/layer/region
subjects = {'01' '02' '03' '04' '05' '06' '07' '08' '09' '10' '11' '12' '13' '14' '15' '16' '17' '18' '19' '20' '21' '22' '23' '24' '25' '26' '27' '28' '29' '30' '31' '32' '33' '34' '35' '36' '37' '38' '39' '40' '41' '42' '43' '44' '45'};
for s=1:length(subjects)
	load(['/home/data/eccolab/Code/NNDb/SEE/outputs/supplementary/sub-' subjects{s} '_pSTS_emofan_late_mean_diag_corr.mat']);
	avgcorr_pSTS_emofan_late(s) = mean(mean_diag_corr);

	load(['/home/data/eccolab/Code/NNDb/SEE/outputs/supplementary/sub-' subjects{s} '_pSTS_emonet_late_mean_diag_corr.mat']);
	avgcorr_pSTS_emonet_late(s) = mean(mean_diag_corr);

	load(['/home/data/eccolab/Code/NNDb/SEE/outputs/supplementary/sub-' subjects{s} '_pSTS_combined_late_mean_diag_corr.mat']);
	avgcorr_pSTS_combined_late(s) = mean(mean_diag_corr);

	load(['/home/data/eccolab/Code/NNDb/SEE/outputs/supplementary/sub-' subjects{s} '_pSTS_emofan_intermediate_mean_diag_corr.mat']);
	avgcorr_pSTS_emofan_intermed(s) = mean(mean_diag_corr);

	load(['/home/data/eccolab/Code/NNDb/SEE/outputs/supplementary/sub-' subjects{s} '_pSTS_emonet_intermediate_mean_diag_corr.mat']);
	avgcorr_pSTS_emonet_intermed(s) = mean(mean_diag_corr);

	load(['/home/data/eccolab/Code/NNDb/SEE/outputs/supplementary/sub-' subjects{s} '_pSTS_combined_intermediate_mean_diag_corr.mat']);
	avgcorr_pSTS_combined_intermed(s) = mean(mean_diag_corr);

	load(['/home/data/eccolab/Code/NNDb/SEE/outputs/supplementary/sub-' subjects{s} '_Amy_emofan_late_mean_diag_corr.mat']);
	avgcorr_amygdala_emofan_late(s) = mean(mean_diag_corr);

	load(['/home/data/eccolab/Code/NNDb/SEE/outputs/supplementary/sub-' subjects{s} '_Amy_emonet_late_mean_diag_corr.mat']);
	avgcorr_amygdala_emonet_late(s) = mean(mean_diag_corr);

	load(['/home/data/eccolab/Code/NNDb/SEE/outputs/supplementary/sub-' subjects{s} '_Amy_combined_late_mean_diag_corr.mat']);
	avgcorr_amygdala_combined_late(s) = mean(mean_diag_corr);

	load(['/home/data/eccolab/Code/NNDb/SEE/outputs/supplementary/sub-' subjects{s} '_Amy_emofan_intermediate_mean_diag_corr.mat']);
	avgcorr_amygdala_emofan_intermed(s) = mean(mean_diag_corr);

	load(['/home/data/eccolab/Code/NNDb/SEE/outputs/supplementary/sub-' subjects{s} '_Amy_emonet_intermediate_mean_diag_corr.mat']);
	avgcorr_amygdala_emonet_intermed(s) = mean(mean_diag_corr);

	load(['/home/data/eccolab/Code/NNDb/SEE/outputs/supplementary/sub-' subjects{s} '_Amy_combined_intermediate_mean_diag_corr.mat']);
	avgcorr_amygdala_combined_intermed(s) = mean(mean_diag_corr);
end

%% compare performance to noise ceiling
pSTS_emofan_late_raw = mean(avgcorr_pSTS_emofan_late);
pSTS_emofan_late_raw_sd = std(avgcorr_pSTS_emofan_late);
pSTS_emofan_late_raw_ci = bootci(10000,@mean,avgcorr_pSTS_emofan_late);
noise_ceiling_pSTS_emofan_late = load('/home/data/eccolab/Code/NNDb/SEE/outputs/supplementary/noise_ceilingpSTSemofan_late.mat');
noise_ceiling_pSTS_emofan_late_true = noise_ceiling_pSTS_emofan_late.mean_diag_corr';
pSTS_emofan_late_percent_ceiling = avgcorr_pSTS_emofan_late./noise_ceiling_pSTS_emofan_late_true;
pSTS_emofan_late_percent_ceiling_ci = bootci(10000,@mean, pSTS_emofan_late_percent_ceiling);

pSTS_emonet_late_raw = mean(avgcorr_pSTS_emonet_late);
pSTS_emonet_late_raw_sd = std(avgcorr_pSTS_emonet_late);
pSTS_emonet_late_raw_ci = bootci(10000,@mean, avgcorr_pSTS_emonet_late);
noise_ceiling_pSTS_emonet_late = load('/home/data/eccolab/Code/NNDb/SEE/outputs/supplementary/noise_ceilingpSTSemonet_late.mat');
noise_ceiling_pSTS_emonet_late_true = noise_ceiling_pSTS_emonet_late.mean_diag_corr';
pSTS_emonet_late_percent_ceiling = avgcorr_pSTS_emonet_late./noise_ceiling_pSTS_emonet_late_true;
pSTS_emonet_late_percent_ceilng_ci = bootci(10000,@mean, pSTS_emonet_late_percent_ceiling);

pSTS_combined_late_raw = mean(avgcorr_pSTS_combined_late);
pSTS_combined_late_raw_sd = std(avgcorr_pSTS_combined_late);
pSTS_combined_late_raw_ci = bootci(10000,@mean, avgcorr_pSTS_combined_late);
noise_ceiling_pSTS_combined_late = load('/home/data/eccolab/Code/NNDb/SEE/outputs/supplementary/noise_ceilingpSTScombined_late.mat');
noise_ceiling_pSTS_combined_late_true = noise_ceiling_pSTS_combined_late.mean_diag_corr';
pSTS_combined_late_percent_ceiling = avgcorr_pSTS_combined_late./noise_ceiling_pSTS_combined_late_true;
pSTS_combined_late_percent_ceiling_ci = bootci(10000,@mean, pSTS_combined_late_percent_ceiling);

amygdala_emofan_late_raw = mean(avgcorr_amygdala_emofan_late);
amygdala_emofan_late_raw_sd = std(avgcorr_amygdala_emofan_late);
amygdala_emofan_late_raw_ci = bootci(10000,@mean, avgcorr_amygdala_emofan_late);
noise_ceiling_amygdala_emofan_late = load('/home/data/eccolab/Code/NNDb/SEE/outputs/supplementary/noise_ceilingAmyemofan_late.mat');
noise_ceiling_amygdala_emofan_late_true = noise_ceiling_amygdala_emofan_late.mean_diag_corr';
amygdala_emofan_late_percent_ceiling = avgcorr_amygdala_emofan_late./noise_ceiling_amygdala_emofan_late_true;
amygdala_emofan_late_percent_ceiling_ci = bootci(10000,@mean, amygdala_emofan_late_percent_ceiling);

amygdala_emonet_late_raw = mean(avgcorr_amygdala_emonet_late);
amygdala_emonet_late_raw_sd = std(avgcorr_amygdala_emonet_late);
amygdala_emonet_late_raw_ci = bootci(10000,@mean, avgcorr_amygdala_emonet_late);
noise_ceiling_amygdala_emonet_late = load('/home/data/eccolab/Code/NNDb/SEE/outputs/supplementary/noise_ceilingAmyemonet_late.mat');
noise_ceiling_amygdala_emonet_late_true = noise_ceiling_amygdala_emonet_late.mean_diag_corr';
amygdala_emonet_late_percent_ceiling = avgcorr_amygdala_emonet_late./noise_ceiling_amygdala_emonet_late_true;
amygdala_emonet_late_percent_ceiling_ci = bootci(10000,@mean, amygdala_emonet_late_percent_ceiling);

amygdala_combined_late_raw = mean(avgcorr_amygdala_combined_late);
amygdala_combined_late_raw_sd = std(avgcorr_amygdala_combined_late);
amygdala_combined_late_raw_ci = bootci(10000,@mean, avgcorr_amygdala_combined_late);
noise_ceiling_amygdala_combined_late = load('/home/data/eccolab/Code/NNDb/SEE/outputs/supplementary/noise_ceilingAmycombined_late.mat');
noise_ceiling_amygdala_combined_late_true = noise_ceiling_amygdala_combined_late.mean_diag_corr';
amygdala_combined_late_percent_ceiling = avgcorr_amygdala_combined_late./noise_ceiling_amygdala_combined_late_true;
amygdala_combined_late_percent_ceilng_ci = bootci(10000,@mean, amygdala_combined_late_percent_ceiling);

pSTS_emofan_int_raw = mean(avgcorr_pSTS_emofan_intermed);
pSTS_emofan_int_raw_ci = bootci(10000,@mean, avgcorr_pSTS_emofan_intermed);

pSTS_emonet_int_raw = mean(avgcorr_pSTS_emonet_intermed);
pSTS_emonet_int_raw_ci = bootci(10000,@mean,avgcorr_pSTS_emonet_intermed);

pSTS_combined_int_raw = mean(avgcorr_pSTS_combined_intermed);
pSTS_combined_int_raw_ci = bootci(10000,@mean, avgcorr_pSTS_combined_intermed);

amygdala_emofan_int_raw = mean(avgcorr_amygdala_emofan_intermed);
amygdala_emofan_int_raw_ci = bootci(10000,@mean, avgcorr_amygdala_emofan_intermed);

amygdala_emonet_int_raw = mean(avgcorr_amygdala_emonet_intermed);
amygdala_emonet_int_raw_ci = bootci(10000,@mean,avgcorr_amygdala_emonet_intermed);

amygdala_combined_int_raw = mean(avgcorr_amygdala_combined_intermed);
amygdala_combined_int_raw_ci = bootci(10000,@mean, avgcorr_amygdala_combined_intermed);

%%
% set up arrays for ANOVAs
X_late = [avgcorr_amygdala_emofan_late' avgcorr_amygdala_emonet_late' avgcorr_amygdala_combined_late' avgcorr_pSTS_emofan_late' avgcorr_pSTS_emonet_late' avgcorr_pSTS_combined_late'];

X_int = [avgcorr_amygdala_emofan_intermed' avgcorr_amygdala_emonet_intermed' avgcorr_amygdala_combined_intermed' avgcorr_pSTS_emofan_intermed' avgcorr_pSTS_emonet_intermed' avgcorr_pSTS_combined_intermed'];

%%
% plot performance of late layers
X_late_z = atanh(X_late)
barplot_columns(X_late_z, 'dolines')
title 'GoT Late Features'
set(gca,'XTickLabel',{'Amygdala EmoFAN' 'Amygdala EmoNet' 'Amygdala Combined' 'pSTS EmoFAN' 'pSTS EmoNet' 'pSTS Combined'})
set(gca,'XLabel',[])
ylabel 'Prediction-Outcome Correlation'

%%
% plot performance of intermediate layers
X_int_z = atanh(X_int)
barplot_columns(X_int_z,'dolines')
title 'GoT Intermediate Features'
set(gca,'XTickLabel',{'Amygdala EmoFAN' 'Amygdala EmoNet' 'Amygdala Combined' 'pSTS EmoFAN' 'pSTS EmoNet' 'pSTS Combined'})
set(gca,'XLabel',[])
ylabel 'Prediction-Outcome Correlation'

%%
% set up region by model ANOVA for late layers
varnames = {'V1' 'V2' 'V3' 'V4' 'V5' 'V6'};
X_late_transformed = atanh(X_late)
t_encoding_performance = array2table(X_late_transformed, 'VariableNames', varnames);
factorNames = {'Region','Model'};
region = categorical([1 1 1  2 2 2])';
model = categorical([1 2 3  1 2 3])';

within = table(region, model, 'VariableNames', factorNames);

rm = fitrm(t_encoding_performance, 'V1-V6~1', 'WithinDesign', within);

lateAnovaTable = ranova(rm, 'WithinModel', "Region*Model");

late_posthocs = multcompare(rm, 'Model','By','Region');

%%
% set up region by model ANOVA for intermediate layers
X_int_transformed = atanh(X_int);
t_encoding_performance_int = array2table(X_int_transformed, 'VariableNames', varnames);

rm_int = fitrm(t_encoding_performance_int, 'V1-V6~1', 'WithinDesign', within);

intAnovaTable = ranova(rm_int, 'WithinModel', "Region*Model");

int_posthocs = multcompare(rm_int, 'Model','By','Region');

%% region by model by depth ANOVA
varnames_3way = {'V1' 'V2' 'V3' 'V4' 'V5' 'V6' 'V7' 'V8' 'V9' 'V10' 'V11' 'V12'};

X_full = atanh([X_int X_late]);

t_encoding_performance_3way = array2table(X_full, 'VariableNames', varnames_3way);

factorNames_3way = {'Region','Depth','Model'};
region_3 = categorical([1 1 1 2 2 2 1 1 1 2 2 2])';
depth_3 = categorical([1 1 1 1 1 1 2 2 2 2 2 2])';
model_3 = categorical([1 2 3 1 2 3 1 2 3 1 2 3])';

within_3 = table(region_3, depth_3, model_3, 'VariableNames',factorNames_3way);

rm_3 = fitrm(t_encoding_performance_3way,'V1-V12~1', 'WithinDesign',within_3);
ranovatbl_3 = ranova(rm_3,'WithinModel','Region*Depth*Model');

%3wayposthocs = multcompare(rm_3, 'Region','By','Depth','By','Model');


%% raincloud plots for these results

figure;
cb = [.635 .078 .184; .466 .674 .188; .301 .745 .933];
varNames = {'Amygdala Intermediate' 'Amygdala Late' 'pSTS Intermediate' 'pSTS Late'};
X_full = atanh([X_int(:,1:3) X_late(:,1:3) X_int(:,4:6) X_late(:,4:6)]);

cm=0;
% for m =[1 4 7 10]
for m=[10]
    cm=cm+1;
    %subplot(1,4,cm)
    d{1}=X_full(:,m); d{2}=X_full(:,m+1); d{3}=X_full(:,m+2);

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
    title(varNames{4})
    axis tight
end
legend([h1{1} h2{1} h3{1}], {'Face', 'Context', 'Combined'});

%% t tests for the difference of the difference

emofan_sts_layer_diff = avgcorr_pSTS_emofan_late - avgcorr_pSTS_emofan_intermed;
emonet_sts_layer_diff = avgcorr_pSTS_emonet_late - avgcorr_pSTS_emonet_intermed;
combined_sts_layer_diff = avgcorr_pSTS_combined_late - avgcorr_pSTS_combined_intermed;

combined_diff_minus_emonet_diff_sts = combined_sts_layer_diff - emonet_sts_layer_diff;

emofan_amyg_layer_diff = avgcorr_amygdala_emofan_late - avgcorr_amygdala_emofan_intermed;
emonet_amyg_layer_diff = avgcorr_amygdala_emonet_late - avgcorr_amygdala_emonet_intermed;
combined_amyg_layer_diff = avgcorr_amygdala_combined_late - avgcorr_amygdala_combined_intermed;

combined_diff_minus_emonet_diff_amyg = combined_amyg_layer_diff - emonet_amyg_layer_diff;

[h_emofan_diffOfDiff, p_emofan_diffOfDiff, ci_emofan_diffOfDiff, stats_emofan_diffOfDiff] = ttest(emofan_sts_layer_diff, emofan_amyg_layer_diff);
[h_emonet_diffOfDiff, p_emonet_diffOfDiff, ci_emonet_diffOfDiff, stats_emonet_diffOfDiff] = ttest(emonet_sts_layer_diff, emonet_amyg_layer_diff);
[h_combined_diffOfDiff, p_combined_diffOfDiff, ci_combined_diffOfDiff, stats_combined_diffOfDiff] = ttest(combined_sts_layer_diff, combined_amyg_layer_diff);

[h_region_DoD, p_region_DoD, ci_region_DoD, stats_regionDoD] = ttest(combined_diff_minus_emonet_diff_sts, combined_diff_minus_emonet_diff_amyg);

