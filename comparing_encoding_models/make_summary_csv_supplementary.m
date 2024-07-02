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
%% make summary table with all encoding model results
summary_table = [avgcorr_amygdala_emofan_intermed' avgcorr_amygdala_emonet_intermed' avgcorr_amygdala_combined_intermed' avgcorr_pSTS_emofan_intermed' avgcorr_pSTS_emonet_intermed' avgcorr_pSTS_combined_intermed' avgcorr_amygdala_emofan_late' avgcorr_amygdala_emonet_late' avgcorr_amygdala_combined_late' avgcorr_pSTS_emofan_late' avgcorr_pSTS_emonet_late' avgcorr_pSTS_combined_late'];
%% write table to csv file
csvwrite('summary_GoT.csv', summary_table);