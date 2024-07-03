% this script performs a correlation between the timecourse of predictions for regions in the face processing 
% network (FFA, OFA, and STS)

% create empty arrays to store the correlations
STS_corr_FFA = [];

STS_corr_OFA = [];

FFA_corr_OFA = [];

Amy_corr_STS = [];

Amy_corr_FFA = [];

Amy_corr_OFA = [];
load('/home/data/eccolab/Code/NNDb/SEE/outputs/amygdala_excluded_voxels.mat')
wh_voxels = excluded_voxels(:,~all(excluded_voxels==1));
% for each subject, load in their yhats
subjects = {'1' '2' '3' '4' '5' '6' '7' '8' '9' '10' '11' '12' '13' '14' '15' '16' '17' '18' '19' '20'};
for s=1:length(subjects)
    STS_yhats = load(['/home/data/eccolab/Code/NNDb/SEE/outputs/sub-' subjects{s} '_pSTS_emofan_late_yhat.mat']);
    FFA_yhats = load(['/home/data/eccolab/Code/NNDb/SEE/outputs/sub-' subjects{s} '_FFA_emofan_late_yhat.mat']);
    OFA_yhats = load(['/home/data/eccolab/Code/NNDb/SEE/outputs/sub-' subjects{s} '_OFA_emofan_late_yhat.mat']);
    Amy_yhats = load(['/home/data/eccolab/Code/NNDb/SEE/outputs/sub-' subjects{s} '_Amy_emofan_late_yhat.mat']);
    Amy_preds(:,wh_voxels(s,:)==0)=Amy_yhats.yhat;

% correlate STS and FFA, add to array
STS_corr_FFA(s) = mean(diag(corr(STS_yhats.yhat, FFA_yhats.yhat)));
% correlate STS and OFA, add to array
STS_corr_OFA(s) = mean(diag(corr(STS_yhats.yhat, OFA_yhats.yhat)));
% correlate OFA and FFA, add to array
FFA_corr_OFA(s) = mean(diag(corr(FFA_yhats.yhat, OFA_yhats.yhat)));
% correlate Amy and STS, add to array
Amy_corr_STS(s) = mean(diag(corr(Amy_yhats.yhat, STS_yhats.yhat)));
% correlate Amy and OFA, add to array
Amy_corr_OFA(s) = mean(diag(corr(Amy_yhats.yhat, OFA_yhats.yhat)));
% correlate Amy and FFA, add to array
Amy_corr_FFA(s) = mean(diag(corr(Amy_yhats.yhat, FFA_yhats.yhat)));

RSM(s,:,:)=corr([STS_yhats.yhat FFA_yhats.yhat OFA_yhats.yhat Amy_preds]);

end

%% z score transform the correlation values
STS_corr_FFA_zscored = atanh(STS_corr_FFA);
STS_corr_OFA_zscored = atanh(STS_corr_OFA);
FFA_corr_OFA_zscored = atanh(FFA_corr_OFA);
Amy_corr_OFA_zscored = atanh(Amy_corr_OFA);
Amy_corr_FFA_zscored = atanh(Amy_corr_FFA);

%% make bar plots for correlations
figure();
corrs = [mean(STS_corr_FFA) mean(STS_corr_OFA) mean(FFA_corr_OFA) mean(Amy_corr_STS) mean(Amy_corr_FFA) mean(Amy_corr_OFA)];
errorHigh = [(mean(STS_corr_FFA) + (std(STS_corr_FFA)/sqrt(20))) (mean(STS_corr_OFA) + (std(STS_corr_OFA)/sqrt(20))) (mean(FFA_corr_OFA) + (std(FFA_corr_OFA)/sqrt(20))) (mean(Amy_corr_STS) + (std(Amy_corr_STS)/sqrt(20))) (mean(Amy_corr_FFA) + (std(Amy_corr_FFA)/sqrt(20))) (mean(Amy_corr_OFA) + (std(Amy_corr_OFA)/sqrt(20)))];
errorLow = [(mean(STS_corr_FFA) - (std(STS_corr_FFA)/sqrt(20))) (mean(STS_corr_OFA) - (std(STS_corr_OFA)/sqrt(20))) (mean(FFA_corr_OFA) - (std(FFA_corr_OFA)/sqrt(20))) (mean(Amy_corr_STS) - (std(Amy_corr_STS)/sqrt(20))) (mean(Amy_corr_FFA) - (std(Amy_corr_FFA)/sqrt(20))) (mean(Amy_corr_OFA) - (std(Amy_corr_OFA)/sqrt(20)))];
bar(corrs, 'FaceColor', [.75 .75 .75]);
set(gca, 'XTickLabel', {'STS-FFA' 'STS-OFA' 'FFA-OFA' 'Amy-STS' 'Amy-FFA' 'Amy-OFA'});
xtickangle(45)
title 'Model Prediction Correlations';
ylabel 'Correlation'
hold on
er = errorbar(1:6, corrs, errorLow, errorHigh);
er.Color = [0 0 0];
er.LineStyle = 'none';
hold off

%% plot correlations between regions
RSM(RSM==0)=NaN;
region = [repmat(1,[size(STS_yhats.yhat,2)],1); repmat(2,[size(FFA_yhats.yhat,2)],1); repmat(3,[size(OFA_yhats.yhat,2)],1);repmat(4,[size(Amy_preds,2)],1)];
[Y str]=mdscale(squareform(1-squeeze(mean(RSM))),2)

%
region_names = {'STS' 'FFA' 'OFA' 'Amy'};
figure;gscatter(Y(:,1),Y(:,2),region_names(region)')
figure;imagesc(squeeze(mean(RSM)))

Z = linkage(squareform(1-squeeze(nanmean(RSM))),'average');
figure;dendrogram(Z,0,'Labels',region_names(region)')

%% average across all the non-core region pairs
non_core_avg = [];
for s=1:20
    non_core_avg(s) = mean([STS_corr_FFA(s) STS_corr_OFA(s) Amy_corr_STS(s) Amy_corr_OFA(s) Amy_corr_FFA(s)])
end

[h,p,ci,stats] = ttest(FFA_corr_OFA, non_core_avg,"Tail","right")
