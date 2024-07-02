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

%% compute raw performance and percent noise ceiling
pSTS_emofan_late_raw = mean(avgcorr_pSTS_EmoFAN_final);
pSTS_emofan_late_raw_ci = bootci(10000,@mean, avgcorr_pSTS_EmoFAN_final);
pSTS_emofan_late_raw_sd = std(avgcorr_pSTS_EmoFAN_final);
noise_ceiling_pSTS_emofan_late = load('/home/data/eccolab/Code/NNDb/SEE/outputs/noise_ceilingpSTSemofan_late.mat');
noise_ceiling_pSTS_emofan_late_true = noise_ceiling_pSTS_emofan_late.mean_diag_corr';
pSTS_emofan_late_percent_ceiling = avgcorr_pSTS_EmoFAN_final./noise_ceiling_pSTS_emofan_late_true;
pSTS_emofan_late_percent_ceiling_ci = bootci(10000,@mean, pSTS_emofan_late_percent_ceiling);

pSTS_emonet_late_raw = mean(avgcorr_pSTS_EmoNet);
pSTS_emonet_late_raw_ci = bootci(10000,@mean, avgcorr_pSTS_EmoNet);
pSTS_emonet_late_raw_sd = std(avgcorr_pSTS_EmoNet);
noise_ceiling_pSTS_emonet_late = load('/home/data/eccolab/Code/NNDb/SEE/outputs/noise_ceilingpSTSemonet_late.mat');
noise_ceiling_pSTS_emonet_late_true = noise_ceiling_pSTS_emonet_late.mean_diag_corr';
pSTS_emonet_late_percent_ceiling = avgcorr_pSTS_EmoNet./noise_ceiling_pSTS_emonet_late_true;
pSTS_emonet_late_percent_ceiling_ci = bootci(10000,@mean, pSTS_emonet_late_percent_ceiling);

pSTS_combined_late_raw = mean(avgcorr_pSTS_multi);
pSTS_combined_late_raw_ci = bootci(10000,@mean, avgcorr_pSTS_multi);
pSTS_combined_late_raw_sd = std(avgcorr_pSTS_multi);
noise_ceiling_pSTS_combined_late = load('/home/data/eccolab/Code/NNDb/SEE/outputs/noise_ceilingpSTScombined_late.mat');
noise_ceiling_pSTS_combined_late_true = noise_ceiling_pSTS_combined_late.mean_diag_corr';
pSTS_combined_late_percent_ceiling = avgcorr_pSTS_multi./noise_ceiling_pSTS_combined_late_true;
pSTS_combined_late_percent_ceiling_ci = bootci(10000,@mean, pSTS_combined_late_percent_ceiling);

amygdala_emofan_late_raw = mean(avgcorr_amygdala_EmoFAN_final);
amygdala_emofan_late_raw_ci = bootci(10000,@mean, avgcorr_amygdala_EmoFAN_final);
amygdala_emofan_late_raw_sd = std(avgcorr_amygdala_EmoFAN_final);
noise_ceiling_amygdala_emofan_late = load('/home/data/eccolab/Code/NNDb/SEE/outputs/noise_ceilingAmyemofan_late.mat');
noise_ceiling_amygdala_emofan_late_true = noise_ceiling_amygdala_emofan_late.mean_diag_corr';
amygdala_emofan_late_percent_ceiling = avgcorr_amygdala_EmoFAN_final./noise_ceiling_amygdala_emofan_late_true;
amygdala_emofan_late_percent_ceiling_ci = bootci(10000,@mean, amygdala_emofan_late_percent_ceiling);

amygdala_emonet_late_raw = mean(avgcorr_amygdala_EmoNet);
amygdala_emonet_late_raw_ci = bootci(10000,@mean, avgcorr_amygdala_EmoNet);
amygdala_emonet_late_raw_sd = std(avgcorr_amygdala_EmoNet);
noise_ceiling_amygdala_emonet_late = load('/home/data/eccolab/Code/NNDb/SEE/outputs/noise_ceilingAmyemonet_late.mat');
noise_ceiling_amygdala_emonet_late_true = noise_ceiling_amygdala_emonet_late.mean_diag_corr';
amygdala_emonet_late_percent_ceiling = avgcorr_amygdala_EmoNet./noise_ceiling_amygdala_emonet_late_true;
amygdala_emonet_late_percent_ceiling_ci = bootci(10000,@mean, amygdala_emonet_late_percent_ceiling);

amygdala_combined_late_raw = mean(avgcorr_amygdala_multi);
amygdala_combined_late_raw_ci = bootci(10000,@mean, avgcorr_amygdala_multi);
amygdala_combined_late_raw_sd = std(avgcorr_amygdala_multi);
noise_ceiling_amygdala_combined_late = load('/home/data/eccolab/Code/NNDb/SEE/outputs/noise_ceilingAmycombined_late.mat');
noise_ceiling_amygdala_combined_late_true = noise_ceiling_amygdala_combined_late.mean_diag_corr';
amygdala_combined_late_percent_ceiling = avgcorr_amygdala_multi./noise_ceiling_amygdala_combined_late_true;
amygdala_combined_late_percent_ceiling_ci = bootci(10000,@mean, amygdala_combined_late_percent_ceiling);

pSTS_emofan_int_raw = mean(avgcorr_pSTS_EmoFAN_conv);
pSTS_emofan_int_raw_ci = bootci(10000,@mean, avgcorr_pSTS_EmoFAN_conv);
pSTS_emofan_int_raw_sd = std(avgcorr_pSTS_EmoFAN_conv);
noise_ceiling_pSTS_emofan_int = load('/home/data/eccolab/Code/NNDb/SEE/outputs/noise_ceilingpSTSemofan_intermed.mat');
noise_ceiling_pSTS_emofan_int_true = noise_ceiling_pSTS_emofan_int.mean_diag_corr';
pSTS_emofan_int_percent_ceiling = avgcorr_pSTS_EmoFAN_conv./noise_ceiling_pSTS_emofan_int_true;
pSTS_emofan_int_percent_ceiling_ci = bootci(10000,@mean, pSTS_emofan_int_percent_ceiling);

pSTS_emonet_int_raw = mean(avgcorr_pSTS_EmoNet_fc7);
pSTS_emonet_int_raw_ci = bootci(10000,@mean, avgcorr_pSTS_EmoNet_fc7);
pSTS_emonet_int_raw_sd = std(avgcorr_pSTS_EmoNet_fc7);
noise_ceiling_pSTS_emonet_int = load('/home/data/eccolab/Code/NNDb/SEE/outputs/noise_ceilingpSTSemonet_intermed.mat');
noise_ceiling_pSTS_emonet_int_true = noise_ceiling_pSTS_emonet_int.mean_diag_corr';
pSTS_emonet_int_percent_ceiling = avgcorr_pSTS_EmoNet_fc7./noise_ceiling_pSTS_emonet_int_true;
pSTS_emonet_int_percent_ceiling_ci = bootci(10000,@mean, pSTS_emonet_int_percent_ceiling);

pSTS_combined_int_raw = mean(avgcorr_pSTS_multi_intermed);
pSTS_combined_int_raw_ci = bootci(10000,@mean, avgcorr_pSTS_multi_intermed);
pSTS_combined_int_raw_sd = std(avgcorr_pSTS_multi_intermed);
noise_ceiling_pSTS_combined_int = load('/home/data/eccolab/Code/NNDb/SEE/outputs/noise_ceilingpSTScombined_intermed.mat');
noise_ceiling_pSTS_combined_int_true = noise_ceiling_pSTS_combined_int.mean_diag_corr';
pSTS_combined_int_percent_ceiling = avgcorr_pSTS_multi_intermed./noise_ceiling_pSTS_combined_int_true;
pSTS_combined_int_percent_ceiling_ci = bootci(10000,@mean, pSTS_combined_int_percent_ceiling);

amygdala_emofan_int_raw = mean(avgcorr_amygdala_EmoFAN_conv);
amygdala_emofan_int_raw_ci = bootci(10000,@mean, avgcorr_amygdala_EmoFAN_conv);
amygdala_emofan_int_raw_sd = std(avgcorr_amygdala_EmoFAN_conv);
noise_ceiling_amygdala_emofan_int = load('/home/data/eccolab/Code/NNDb/SEE/outputs/noise_ceilingAmyemofan_intermed.mat');
noise_ceiling_amygdala_emofan_int_true = noise_ceiling_amygdala_emofan_int.mean_diag_corr';
amygdala_emofan_int_percent_ceiling = avgcorr_amygdala_EmoFAN_conv./noise_ceiling_amygdala_emofan_int_true;
amygdala_emofan_int_percent_ceiling_ci = bootci(10000,@mean, amygdala_emofan_int_percent_ceiling);

amygdala_emonet_int_raw = mean(avgcorr_amygdala_EmoNet_fc7);
amygdala_emonet_int_raw_ci = bootci(10000,@mean, avgcorr_amygdala_EmoNet_fc7);
amygdala_emonet_int_raw_sd = std(avgcorr_amygdala_EmoNet_fc7);
noise_ceiling_amygdala_emonet_int = load('/home/data/eccolab/Code/NNDb/SEE/outputs/noise_ceilingAmyemonet_intermed.mat');
noise_ceiling_amygdala_emonet_int_true = noise_ceiling_amygdala_emonet_int.mean_diag_corr';
amygdala_emonet_int_percent_ceiling = avgcorr_amygdala_EmoNet_fc7./noise_ceiling_amygdala_emonet_int_true;
amygdala_emonet_int_percent_ceiling_ci = bootci(10000,@mean, amygdala_emonet_int_percent_ceiling);

amygdala_combined_int_raw = mean(avgcorr_amygdala_multi_intermed);
amygdala_combined_int_raw_ci = bootci(10000,@mean, avgcorr_amygdala_multi_intermed);
amygdala_combined_int_raw_sd = std(avgcorr_amygdala_multi_intermed);
noise_ceiling_amygdala_combined_int = load('/home/data/eccolab/Code/NNDb/SEE/outputs/noise_ceilingAmycombined_intermed.mat');
noise_ceiling_amygdala_combined_int_true = noise_ceiling_amygdala_combined_int.mean_diag_corr';
amygdala_combined_int_percent_ceiling = avgcorr_amygdala_multi_intermed./noise_ceiling_amygdala_combined_int_true;
amygdala_combined_int_percent_ceiling_ci = bootci(10000,@mean, amygdala_combined_int_percent_ceiling);


%% make array of all performance results
%colnames = ['amygdala_emoFAN_late' 'amygdala_emoNet_late' 'amygdala_multi_late' 'pSTS_emoFAN_late' 'pSTS_emoNet_late' 'pSTS_multi_late' 
    %'amygdala_emoFAN_int' 'amygdala_emoNet_int' 'amygdala_multi_int' 'pSTS_emoFAN_int' 'pSTS_emoNet_int' 'pSTS_multi_int']
X_all = [avgcorr_amygdala_EmoFAN_final' avgcorr_amygdala_EmoNet' avgcorr_amygdala_multi' avgcorr_pSTS_EmoFAN_final' avgcorr_pSTS_EmoNet' avgcorr_pSTS_multi' avgcorr_amygdala_EmoFAN_conv' avgcorr_amygdala_EmoNet_fc7' avgcorr_amygdala_multi_intermed' avgcorr_pSTS_EmoFAN_conv' avgcorr_pSTS_EmoNet_fc7' avgcorr_pSTS_multi_intermed']
% csvwrite("avgcorr_all_conditions.csv", X_all)
%% plot performance of final fully connected layers
X_late = [ avgcorr_amygdala_EmoFAN_final' avgcorr_amygdala_EmoNet' avgcorr_amygdala_multi' avgcorr_pSTS_EmoFAN_final' avgcorr_pSTS_EmoNet'  avgcorr_pSTS_multi'];
X_late_z = atanh(X_late)
%plot late layers
barplot_columns(X_late,'dolines')
title 'Late Features'
set(gca,'XTickLabel',{'Amygdala EmoFAN' 'Amygdala EmoNet'  'Amygdala Multi' 'pSTS EmoFAN' 'pSTS EmoNet' 'pSTS Multi'})
set(gca,'Xlabel',[])
ylabel 'Prediction-Outcome Correlation'

%% plot performance of intermediate layers (convolutional layer/fc7)
X_int = [ avgcorr_amygdala_EmoFAN_conv' avgcorr_amygdala_EmoNet_fc7' avgcorr_amygdala_multi_intermed' avgcorr_pSTS_EmoFAN_conv' avgcorr_pSTS_EmoNet_fc7'  avgcorr_pSTS_multi_intermed'];
X_int_z = atanh(X_int)
%plot intermediate layers
barplot_columns(X_int,'dolines')
title 'Intermediate Features'
set(gca,'XTickLabel',{'Amygdala EmoFAN' 'Amygdala EmoNet'  'Amygdala Multi' 'pSTS EmoFAN' 'pSTS EmoNet' 'pSTS Multi'})
set(gca,'Xlabel',[])
ylabel 'Prediction-Outcome Correlation'

%% 2 way anova with ROI and model as factors (2 by 3) for late only
for v=1:6
    varNames{v}=['V' num2str(v)];
end
x_full = atanh(X_late)

t_encoding_performance = array2table(x_full, 'VariableNames', varNames);
factorNames = {'Region','Model'};
region = categorical([1 1 1  2 2 2])';
model = categorical([1 2 3  1 2 3])';

within = table(region, model, 'VariableNames',factorNames);

rm = fitrm(t_encoding_performance, 'V1-V6~1', 'WithinDesign', within, 'WithinModel','orthogonalcontrasts');

lateAnovaTable = ranova(rm, 'WithinModel', "Region*Model")

late_table_posthocs = multcompare(rm,'Model','By','Region')

%save("2way_anova_table_late.mat","lateAnovaTable")
%% 2 way anova with ROI and model as factors (2 by 3) for intermediate only
for v=1:6
    varNames2{v}=['V' num2str(v)];
end
x_int = atanh(X_int)

t_encoding_performance = array2table(X_int, 'VariableNames', varNames2);
factorNames = {'Region','Model'};
region = categorical([1 1 1  2 2 2])';
model = categorical([1 2 3  1 2 3])';

within = table(region, model, 'VariableNames', factorNames);

rm = fitrm(t_encoding_performance, 'V1-V6~1', 'WithinDesign', within);

intAnovaTable = ranova(rm, 'WithinModel', "Region*Model")
int_table_posthocs = multcompare(rm,'Model','By','Region')

%save('2way_anova_table_int','intAnovaTable')

%% repeated measures anova with ROI, depth, and model as factors (2 by 2 by 3)

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

%% run mauchly's test of sphericity on the rm model
sphericity = mauchly(rm)

%% compute epsilon adjustment factors for repeated measures anova
epsilonTest = epsilon(rm)
%% 2-way anova comparing model and depth for Amygdala 
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

%% 2 way anova comparing model and depth for pSTS 
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



%% plotting results with box plots and rain cloud plots
figure;
cb = [.635 .078 .184; .466 .674 .188; .301 .745 .933];
varNames = {'Amygdala Intermediate' 'Amygdala Late' 'pSTS Intermediate'  'pSTS Late'};
X_full = atanh([X_int(:,1:3) X_late(:,1:3) X_int(:,4:6) X_late(:,4:6)]);

cm=0;
for m=[10]
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
    title(varNames{4})
    % save
%     view([90 -90]);
%     axis ij
    axis tight

end
    legend([h1{1} h2{1} h3{1}], {'Face', 'Context' 'Combined'});
%% post-hoc t-tests to compare intermediate vs. late performance for each model and region

[h_emofan_amyg,p_emofan_amyg,ci_emofan_amyg,stats_emofan_amyg] = ttest(amygdala_emofan_late_percent_ceiling, amygdala_emofan_int_percent_ceiling);
[h_emonet_amyg,p_emonet_amyg,ci_emonet_amyg,stats_emonet_amyg] = ttest(amygdala_emonet_late_percent_ceiling, amygdala_emonet_int_percent_ceiling);

[h_emofan_sts,p_emofan_sts,ci_emofan_sts,stats_emofan_sts] = ttest(pSTS_emofan_late_percent_ceiling, pSTS_emofan_int_percent_ceiling);
[h_emonet_sts,p_emonet_sts,ci_emonet_sts,stats_emonet_sts] = ttest(pSTS_emonet_late_percent_ceiling, pSTS_emonet_int_percent_ceiling);

%% t tests for the difference of the difference
emofan_sts_layer_diff = pSTS_emofan_late_percent_ceiling - pSTS_emofan_int_percent_ceiling;
emonet_sts_layer_diff = pSTS_emonet_late_percent_ceiling - pSTS_emonet_int_percent_ceiling;
combined_sts_layer_diff = pSTS_combined_late_percent_ceiling - pSTS_combined_int_percent_ceiling;

emofan_amyg_layer_diff = amygdala_emofan_late_percent_ceiling - amygdala_emofan_int_percent_ceiling;
emonet_amyg_layer_diff = amygdala_emonet_late_percent_ceiling - amygdala_emonet_int_percent_ceiling;
combined_amyg_layer_diff = amygdala_combined_late_percent_ceiling - amygdala_combined_int_percent_ceiling;

[h_emofan_diffOfDiff, p_emofan_diffOfDiff, ci_emofan_diffOfDiff, stats_emofan_diffOfDiff] = ttest(emofan_sts_layer_diff, emofan_amyg_layer_diff);
[h_emonet_diffOfDiff, p_emonet_diffOfDiff, ci_emonet_diffOfDiff, stats_emonet_diffOfDiff] = ttest(emonet_sts_layer_diff, emonet_amyg_layer_diff);
[h_combined_diffOfDiff, p_combined_diffOfDiff, ci_combined_diffOfDiff, stats_combined_diffOfDiff] = ttest(combined_sts_layer_diff, combined_amyg_layer_diff);

%% getting stats for the difference between single and combined
amyg_combined_minus_emonet = avgcorr_amygdala_multi - avgcorr_amygdala_EmoNet;
mean(amyg_combined_minus_emonet)
std(amyg_combined_minus_emonet)

sts_combined_minus_emonet = avgcorr_pSTS_multi - avgcorr_pSTS_EmoNet;
mean(sts_combined_minus_emonet)
std(sts_combined_minus_emonet)

