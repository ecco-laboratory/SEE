
%%
load netTransfer_20cat.mat
featureLayer = 'fc7';
vids=dir(['/home/gjang/Stimuli/500_days_of_summer.mp4']);
%%
cc=0;
% for v=1:length(vids)
    cc=cc+1;
    clear video_*

    vid=VideoReader(['/home/gjang/Stimuli/500_days_of_summer.mp4']);

    numFrames = vid.NumberOfFrames;
    n=numFrames;ci=0;
%             figure(1);set(gcf,'Units','Inches')
%             set(gcf,'Position',[0 0 16 9]/3);
% 
% %     create the video writer with 1 fps
%              writerObj = VideoWriter([vids(v).name(1:end-3) 'avi']);
%              writerObj.FrameRate = vid.FrameRate/5;
% %     open the video writer
%             open(writerObj);
    for i = 1:5:n
        ci=ci+1;
        img = read(vid,i);
%        imwrite(img,'tv.jpg');
        img = readAndPreprocessImage (img);

        % Extract image features using the CNN
        temp_variable = activations(netTransfer,img,featureLayer);
        video_imageFeatures(ci,:)  = temp_variable(:);
        [video_maxval(ci),video_pred_label(ci)]=max(video_imageFeatures(ci,:),[],2);
        %             %
%                         figure(1);
%                         imagesc(img);
%                         set(gca,'XTick',[]);
%                         set(gca,'YTick',[]);
%                         toprint=[categories{video_pred_label(ci)} ': ' num2str(video_maxval(ci))];
%         
%                         bk_color=squeeze(mean(mean(img(210:227,1:60,:))))';
%                         if mean(mean(bk_color))<125
%                         col=[1 1 1];
%                         else
%                         col=[0 0 0];
%                         end
%                         text(1,218,toprint,'Color',col,'FontWeight','Bold','FontSize',12);
%         
%                         set(gca,'units','pixels') % set the axes units to pixels
%                         x = get(gca,'position'); % get the position of the axes
%                         set(gcf,'units','pixels') % set the figure units to pixels
%                         y = get(gcf,'position'); % get the figure position
%                         set(gcf,'position',[y(1) y(2) x(3) x(4)])% set the position of the figure to the length and width of the axes
%                         set(gca,'units','normalized','position',[0 0 1 1]) % set the axes units to pixels
%         
%                                     %
%                           writeVideo(writerObj, getframe(gcf));
    end
    % close the writer object
%     close(writerObj);
    avg_features(cc,:)=mean(video_imageFeatures);

    save('500_days_of_summer_fc7_features','video_imageFeatures', '-v7.3')
% 
% end
%

