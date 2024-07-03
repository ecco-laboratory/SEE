addpath('/home/data/eccolab/CowenKeltner/Code')
load netTransfer_20cat.mat

imgs=dir(['/home/data/eccolab/Code/NNDb/SEE/supplementary_analyses/CowenKeltner_test_images/*.jpg']);
c=1;
ci=0;


for i=1:length(imgs)
     newImage = [imgs(i).folder '/' imgs(i).name];
    
    try
        % Pre-process the images as required for the CNN
        img = readAndPreprocessImage(newImage);
        ci=ci+1;
        usedimgs(ci)=i;
        
        % Extract image features using the CNN
        tv = activations(netTransfer, img, 'fc'); %'fc7' 
        
        imageFeatures(ci,:) = tv(:);
        [maxval(ci),pred_label(ci)]=max(imageFeatures(ci,:),[],2);


    catch
    end
end

%%
labels = readtable('/home/data/eccolab/Code/NNDb/SEE/supplementary_analyses/dev/CK_image_list_minus1.csv');
y=categorical(labels.emotion);
imageFeatures = zscore(imageFeatures);

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

%% get mean area under the ROC curve
rocobj = rocmetrics(gt, yhat, unique(gt));
mean(rocobj.AUC)

%% make roc curve
figure;
hold on; plot([0 1],[0 1],'k-')
categories = {'Chance' 'Adoration'	'Aesthetic Appreciation' 'Amusement' 'Anxiety'	'Awe'	'Boredom'	'Confusion'  'Craving'		'Disgust'	'Empathic Pain'	'Entrancement'		'Excitement'	'Fear'	'Horror'	'Interest'	'Joy'	'Romance'	'Sadness'	  'Sexual Desire'	'Surprise'};
C=[ 220 35 35; 123 216 57; 20 21 53; 243 210 49; 60 97 32; 144 86 78; 84 138 152; 19 18 123; 179 216 110; 231 178 225; 185 44 249; 116 49 116; 211 28 97; 239 193 138; 43 44 24; 32 32 32; 155 229 232; 164 190 252; 138 10 10; 71 102 250]/255;
for n=1:20
    [x y] = perfcurve(gt,yhat(:,n),n);
    plot(x,y,'Color',C(n,:),'LineWidth',2)
end
ylabel 'Sensitivity'
xlabel '1 - Specificity'
legend(flipud(findobj(gca,'LineStyle','-')),categories)
set(findobj(gca,'Marker','o'),'Marker','.','MarkerSize',20);
set(gca,'FontSize',10)

%% make confusion matrix for betas
figure; imagesc(b(2:end,:))
set(gca,'XTickLabel',categories(2:end))
set(gca,'XTick',1:20)
set(gca,'YTickLabel',categories(2:end))
set(gca,'YTick',1:20)

%% make cluster confusion matrix
[~,preds] = max(yhat,[],2);
[k,stats_pls] = cluster_confusion_matrix(preds, gt,'labels',{'Adoration' 'Aesthetic Appreciation' 'Amusement' 'Anxiety' 'Awe' 'Boredom' 'Confusion' 'Craving' 'Disgust' 'Empathic Pain' 'Entrancement' 'Excitement' 'Fear' 'Horror' 'Interest' 'Joy' 'Romance' 'Sadness' 'Sexual Desire' 'Surprise'},'method', 'ward','dofig', 'bootstrap');

