%this script takes .txt file outputs from emofan applied to kdef test clips
%and performs PLS-DA to classify face images into clusters defined by a
%group of expert human raters


labels = readtable('/home/data/eccolab/KDEF_and_AKDEF/StraightOnFaces/images.csv');
activations = readtable('emofan_late_KDEF.txt');


X=zscore(table2array(activations));
Y=zscore(condf2indic(categorical(labels.emotion)));
kinds = crossvalind('kfold',length(Y),5);
% [~,~,char_ind]=unique(character);
% PLS-DA classifying emofan activation into clusters from raters
[~,Y_gt] = max(Y,[],2);

for k = 1:max(kinds)

                train=kinds~=k;
                test=~train;
                [~,~,~,~,bpls] = plsregress(X(train,:),Y(train,:),10); %100 dimensions, more? less?

                Yhat(test,:)=[ones(length(Y(test)),1) double(X(test,:))]*bpls;
end
[~,inds]=max(Yhat,[],2);
cm=confusionmat(Y_gt,inds);
acc = sum(diag(cm))./sum(cm(:));
cm = bsxfun(@rdivide,cm,sum(cm,2));

%% make confusion matrix for betas
lbls = {'Fear','Anger','Disgust','Happiness','Neutral','Sad','Surprise'};
ef_units ={'Neutral' 'Happy' 'Sad' 'Surprise' 'Fear' 'Disgust' 'Anger' 'Contempt' 'Valence' 'Arousal'};

figure; imagesc(bpls(2:end,:))
set(gca,'XTickLabel',lbls)
set(gca,'XTick',1:7)
set(gca,'YTicklabel',ef_units)
set(gca,'YTick',1:10)

%% get mean area under the ROC curve
rocobj = rocmetrics(Y_gt,Yhat,unique(Y_gt));
mean(rocobj.AUC)
figure; hold on;


%% make ROC curve for each category
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
[x y] = perfcurve(Y_gt,Yhat(:,e),e);
plot(x,y,'Color',C(e,:),'LineWidth',2)
end
ylabel 'Sensitivity'
xlabel '1 - Specificity'
legend(flipud(findobj(gca,'LineStyle','-')),{'Chance','Fear','Anger','Disgust','Happiness','Neutral','Sad','Surprise'})
set(findobj(gca,'Marker','o'),'Marker','.','MarkerSize',20);
set(gca,'FontSize',10)

%% make cluster confusion matrix
[~,preds] = max(Yhat,[],2);
[k,stats_pls] = cluster_confusion_matrix(preds,Y_gt,'labels',{'Fear','Anger','Disgust','Happiness','Neutral','Sad','Surprise'},'method', 'ward','dofig', 'bootstrap');
