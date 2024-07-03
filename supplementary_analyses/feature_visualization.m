%% load features from intermediate and late layers of both EmoNet and EmoFAN
load('500_days_of_summer_fc8_features.mat')
emonet_late = video_imageFeatures;
load('500_days_of_summer_fc7_features.mat')
emonet_imed = video_imageFeatures;
emofan_late = table2array(readtable('/home/data/eccolab/Code/GitHub/emonet/emonet_face_output_NNDB_lastFC.txt'));
emofan_imed = table2array(readtable(which('emoFAN_NNDB_lastConv_total.txt')));
emofan_late=emofan_late(1:5:end,:);
emofan_imed=emofan_imed(1:5:end,:);
rsm_emonet_late = corr(emonet_late');
rsm_emonet_imed = corr(emonet_imed');
rsm_emofan_late = corr(emofan_late');
rsm_emofan_imed = corr(emofan_imed');
rsm_all_models = corr([squareform(1-rsm_emonet_imed)' squareform(1-rsm_emonet_late)' squareform(1-rsm_emofan_imed)' squareform(1-rsm_emofan_late)']);

%% plot correlations between features of all models
figure;imagesc(rsm_all_models);colorbar; set(gca,'XTick',1:4,'YTick',1:4,'XTickLabel',{'EmoNet Intermediate' 'EmoNet Late' 'EmoFAN Intermediate' 'EmoFAN Late'},'YTickLabel',{'EmoNet Intermediate' 'EmoNet Late' 'EmoFAN Intermediate' 'EmoFAN Late'})

%% subplots
figure;
subplot(1,4,1)
imagesc(rsm_emonet_imed);colorbar; 
subplot(1,4,2)
imagesc(rsm_emonet_late);colorbar; 
subplot(1,4,3)
imagesc(rsm_emonet_imed);colorbar; 
subplot(1,4,4)
imagesc(rsm_emofan_late);colorbar; 

%% run t-stochastic neighbor embedding visualization for each layer/model combination, starting with the same random seed
init_Y = 1e-4*randn(27356,2);
Y_emonet_late = tsne(emonet_late,'InitialY',init_Y);
Y_emonet_intermed = tsne(emonet_imed,'InitialY',init_Y);
Y_emofan_late = tsne(emofan_late,'InitialY',init_Y);
Y_emofan_intermed = tsne(emofan_imed,'InitialY',init_Y);

%% plot tSNE results
figure;
subplot(2,2,1)
scatter(Y_emonet_intermed(:,1),Y_emonet_intermed(:,2),10,1:27356,'.');colorbar; 
axis tight
title 'EmoNet Intermediate'
subplot(2,2,2)
scatter(Y_emonet_late(:,1),Y_emonet_late(:,2),10,1:27356,'.');colorbar; 
title 'EmoNet Late'
axis tight

subplot(2,2,3)
scatter(Y_emofan_intermed(:,1),Y_emofan_intermed(:,2),10,1:27356,'.');colorbar; 
title 'EmoFAN Intermediate'
axis tight

subplot(2,2,4)
scatter(Y_emofan_late(:,1),Y_emofan_late(:,2),10,1:27356,'.');colorbar; 
title 'EmoFAN Late'
axis tight


%%

X = [squareform(1-rsm_emonet_imed)' squareform(1-rsm_emonet_late)' squareform(1-rsm_emofan_imed)' squareform(1-rsm_emofan_late)'];

for it=1:1000
bX = X(randsample(size(X,1),size(X,1)),:);
    
    rsm_all_models = corr(bX);
bsw(it)=nanmean([rsm_all_models(2,1) rsm_all_models(4,3)])
bsb(it)=nanmean([rsm_all_models(3:4,2); rsm_all_models(3:4,2)])
end

sem_bsb=std(bsb);
sem_bsw=std(bsw);