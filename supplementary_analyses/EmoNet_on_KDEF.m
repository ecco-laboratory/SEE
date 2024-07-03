labels = readtable('/home/data/eccolab/KDEF_and_AKDEF/StraightOnFaces/images.csv');


addpath('/home/data/eccolab/CowenKeltner/Code')
load netTransfer_20cat.mat
%%
c=1;
ci=0;


for i=1:height(labels)
     newImage = ['/home/data/eccolab/KDEF_and_AKDEF/StraightOnFaces/' labels.filename{i}];
    
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
y = categorical(labels.emotion);
imageFeatures  = zscore(imageFeatures);
%%
ymat = condf2indic(y);
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
cm = bsxfun(@rdivide,cm,sum(cm,2));

lbls = {'Fear','Anger','Disgust','Happiness','Neutral','Sad','Surprise'};

%% get mean area under the ROC curve
rocobj = rocmetrics(y,yhat,unique(y));
rocobj.plot
mean(rocobj.AUC)

%% make confusion matrix for betas
figure; imagesc(b(2:end,:))
set(gca,'XTickLabel',lbls)
set(gca,'XTick',1:7)
set(gca,'YTicklabel',netTransfer.Layers(end).Classes)
set(gca,'YTick',1:20)

%% make cluster confusion matrix
[~,preds] = max(yhat,[],2);
[k,stats_pls] = cluster_confusion_matrix(preds,gt,'labels',{'Fear','Anger','Disgust','Happiness','Neutral','Sad','Surprise'},'method', 'ward','dofig');

%% make roc curve
C = [166,206,227
31,120,180
178,223,138
51,160,44
251,154,153
227,26,28
253,191,111]/255; % we can change if we want...

figure;
hold on; plot([0 1],[0 1],'k-')
for e=1:7;
% ROC = roc_plot(Yhat(:,e),Y_gt==e,'color',C(e,:));
[x yy] = perfcurve(y,yhat(:,e),e);
plot(x,yy,'Color',C(e,:),'LineWidth',2)
end
ylabel 'Sensitivity'
xlabel '1 - Specificity'
legend(flipud(findobj(gca,'LineStyle','-')),{'Chance','Fear','Anger','Disgust','Happiness','Neutral','Sad','Surprise'})
set(findobj(gca,'Marker','o'),'Marker','.','MarkerSize',20);
set(gca,'FontSize',10)
