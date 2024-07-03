
addpath(genpath('/home/data/eccolab/Code/GitHub'))
%% load in labels for the emotion categories of all the images
labels = readtable('/home/data/eccolab/Code/NNDb/SEE/supplementary_analyses/dev/CK_image_list_minus1.csv');
y=categorical(labels.emotion);

%% load in the image features extracted by emofan
t = readtable('/home/data/eccolab/Code/GitHub/emonet/CK_emoFAN_output_lastFC.txt');
imageFeatures = zscore(table2array(t));

%% 
ymat = zscore(condf2indic(y));
kinds = crossvalind('k',length(ymat),5);
for k=1:max(kinds)
train = kinds~=k;
test = ~train;
[~,~,~,~,b] = plsregress(imageFeatures(train,:),ymat(train,:),10); % b = regression coefficient (beta)
yhat(kinds==k,:)=[ones(length(find(test)),1) imageFeatures(test,:)]*b;
end
[~,preds] = max(yhat,[],2);
[~,gt]=max(ymat,[],2);
cm=confusionmat(gt,preds)
accuracy = sum(diag(cm))./sum(cm(:))

%%
rocobj = rocmetrics(gt, yhat, unique(gt));
mean(rocobj.AUC)

%% make confusion matrix for betas
figure; imagesc(b(2:end,:))
set(gca,'YTickLabel',{'Neutral' 'Happy' 'Sad' 'Surprise' 'Fear' 'Disgust' 'Anger' 'Contempt' 'Valence' 'Arousal'})
set(gca,'YTick',1:10)
set(gca,'XTickLabel',{'Adoration' 'Aesthetic Appreciation' 'Amusement' 'Anxiety' 'Awe' 'Boredom' 'Confusion' 'Craving' 'Disgust' 'Empathic Pain' 'Entrancement' 'Excitement' 'Fear' 'Horror' 'Interest' 'Joy' 'Romance' 'Sadness' 'Sexual Desire' 'Surprise'})
set(gca,'XTick',1:20)

%% make cluster confusion matrix
[k,stats_pls] = cluster_confusion_matrix(preds, gt,'labels',{'Adoration' 'Aesthetic Appreciation' 'Amusement' 'Anxiety' 'Awe' 'Boredom' 'Confusion' 'Craving' 'Disgust' 'Empathic Pain' 'Entrancement' 'Excitement' 'Fear' 'Horror' 'Interest' 'Joy' 'Romance' 'Sadness' 'Sexual Desire' 'Surprise'},'method','ward','dofig','bootstrap');

%% make roc curve
figure;
hold on; plot([0 1],[0 1],'k-')
categories = {'Chance' 'Adoration' 'Aesthetic Appreciation' 'Amusement' 'Anxiety' 'Awe' 'Boredom' 'Confusion' 'Craving' 'Disgust' 'Empathic Pain' 'Entrancement' 'Excitement' 'Fear' 'Horror' 'Interest' 'Joy' 'Romance' 'Sadness' 'Sexual Desire' 'Surprise'};
C = [37 37 250; 220 35 35; 123 216 57; 20 21 53; 219 33 180; 243 210 49; 60 97 32; 146 146 250; 144 86 78; 138 237 181; 84 138 152; 19 18 123; 179 216 110; 231 178 225; 185 44 249; 116 49 116; 211 28 97; 239 193 138; 43 44 24; 32 32 32; 221 138 47;]/255;

for n=1:20
    [x y] = perfcurve(gt,yhat(:,n),n);
    plot(x,y,'Color',C(n,:),'LineWidth',2)
end
ylabel 'Sensitivity'
xlabel '1 - Specificity'
legend(flipud(findobj(gca,'LineStyle','-')),categories)
set(findobj(gca,'Marker','o'),'Marker','.','MarkerSize',20);
set(gca,'FontSize',10)

