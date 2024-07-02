
%%
% load emonet model
load netTransfer_20cat.mat
% specify final layer of the model to be extracted
featureLayer = 'fc7';
% specify path where the movie file is
% note: edit to indicate path on your local system
vid_path=('/Users/katherinesoderberg/Downloads/GameofThronesv1.mov');

clear video_*

vid=VideoReader(vid_path);

numFrames = vid.NumberOfFrames;
n=numFrames;ci=0;

for i = 1:5:n
    ci=ci+1;
    img = read(vid,i);
    img = readAndPreprocessImage (img);

    % Extract image features using the CNN
    temp_variable = activations(netTransfer,img,featureLayer);
    video_imageFeatures(ci,:)  = temp_variable(:);
    %[video_maxval(ci),video_pred_label(ci)]=max(video_imageFeatures(ci,:),[],2);
 
end

    %avg_features(1,:)=mean(video_imageFeatures);

    save('Game_of_Thrones_fc7_features','video_imageFeatures', '-v7.3')
% 
% end
%

