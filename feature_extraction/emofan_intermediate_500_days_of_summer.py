
import numpy as np
from pathlib import Path
import argparse
import csv

import torch
from torch import nn
from torch.utils.data import DataLoader
from torch.utils.data.sampler import WeightedRandomSampler
from torchvision import transforms 

from emonet.models import EmoNet
from emonet.data import MELD_clips
from emonet.metrics import CCC, PCC, RMSE, SAGR, ACC
from emonet.evaluation import evaluate, evaluate_flip
from emonet.data_augmentation import DataAugmentor

from sklearn.cross_decomposition import PLSRegression
from sklearn.model_selection import cross_val_predict
from sklearn.metrics import mean_squared_error, r2_score
from sklearn.preprocessing import OneHotEncoder


torch.backends.cudnn.benchmark =  True

#Parse arguments
parser = argparse.ArgumentParser()
parser.add_argument('--nclasses', type=int, default=8, choices=[5,8], help='Number of emotional classes to test the model on. Please use 5 or 8.')
args = parser.parse_args()

# Parameters of the experiments
n_expression = args.nclasses
batch_size = 64 #32
n_workers = 16
device = 'cuda:0'
image_size = 256
subset = 'test'
metrics_valence_arousal = {'CCC':CCC, 'PCC':PCC, 'RMSE':RMSE, 'SAGR':SAGR}
metrics_expression = {'ACC':ACC}

# Create the data loaders
transform_image = transforms.Compose([transforms.ToTensor()])
transform_image_shape_no_flip = DataAugmentor(image_size, image_size)



print(f'Testing the model on {n_expression} emotional classes')

print('Loading the data')
# NOTE: Update the test_dataset_no_flip variable with the paths to the labels.csv file and frames from the movie as they are on your local system
test_dataset_no_flip = MELD_clips(annotations_file='/home/data/eccolab/OpenNeuro/ds002837/stimuli/500_days_of_summer/labels.csv', img_dir='/home/data/eccolab/OpenNeuro/ds002837/stimuli/500_days_of_summer/frames/',transform_image_shape=transform_image_shape_no_flip, transform_image=transform_image)
test_dataloader_no_flip = DataLoader(test_dataset_no_flip, batch_size=batch_size, shuffle=False, num_workers=n_workers)



# Loading the model 
state_dict_path = Path(__file__).parent.joinpath('pretrained', f'emonet_{n_expression}.pth')

print(f'Loading the model from {state_dict_path}.')
state_dict = torch.load(str(state_dict_path), map_location='cpu')
state_dict = {k.replace('module.',''):v for k,v in state_dict.items()}
net = EmoNet(n_expression=n_expression).to(device)
net.load_state_dict(state_dict, strict=False)
net.eval()


print(f'Testing on {subset}-set')
print(f'------------------------')
#evaluate_flip(net, test_dataloader_no_flip, test_dataloader_no_flip, device=device, metrics_valence_arousal=metrics_valence_arousal, metrics_expression=metrics_expression)
#evaluate(net, test_dataloader_no_flip, device=device)

net.eval()

expr = []
lastConv_total = []


# a dict to store the activations
activation = {}
def getActivation(name):
    # the hook signature
    def hook(model, input, output):
        activation[name] = output.detach()
    return hook

# set up hooks
actsFromLastConv_1 = net.emo_net_2[6].conv1.register_forward_hook(getActivation('lastConv1'))
actsFromLastConv_2 = net.emo_net_2[6].conv2.register_forward_hook(getActivation('lastConv2'))
actsFromLastConv_3 = net.emo_net_2[6].conv3.register_forward_hook(getActivation('lastConv3'))
#actsFromPenultFC = net.emo_fc_2[0].register_forward_hook(getActivation('penultFC'))
#actsFromLastFC = net.emo_fc_2[3].register_forward_hook(getActivation('lastFC'))
print(f'Hooks are set up')
lastConv_1_list, lastConv_2_list, lastConv_3_list = [], [], []

with open('emoFAN_NNDB_lastConv_total.txt', 'a') as output_file:

    #get activations from each of the layers 
    counter = 0
    for index, data in enumerate(test_dataloader_no_flip):
        images = data['image'].to(device)
        expression = data.get('expression', None)
        with torch.no_grad():
            out = net(images)
        numimgs = images.shape
        numimgs = numimgs[0]
        temp_V = torch.reshape(activation['lastConv1'],(numimgs,-1,))
        temp_W = torch.reshape(activation['lastConv2'],(numimgs,-1,))
        temp_X = torch.reshape(activation['lastConv3'],(numimgs,-1,))
    #    temp_X_2 = temp_X.unsqueeze(0)
        #temp_Y = torch.reshape(activation['penultFC'],(numimgs,-1,))
    #    temp_Y_2 = temp_Y.unsqueeze(0)
        #temp_Z = torch.reshape(activation['lastFC'],(numimgs,-1,))
    #    temp_Z_2 = temp_Z.unsqueeze(0)
    #    print(temp_X.shape)

        lastConv_1_list = temp_V.cpu().numpy()
        lastConv_2_list = temp_W.cpu().numpy()
        lastConv_3_list = temp_X.cpu().numpy()
           #penultFC_list = np.append(penultFC_list, temp_Y.cpu().numpy(), axis = 0)
           #lastFC_list = np.append(lastFC_list, temp_Z.cpu().numpy(), axis = 0)
        expr_tmp = out['expression']
        total_lastConv_temp = np.concatenate((lastConv_1_list, lastConv_2_list, lastConv_3_list), axis = 1)
        counter += 1
        np.savetxt(output_file,total_lastConv_temp)
        expr = np.append(expr, np.argmax(np.squeeze(expr_tmp.cpu().numpy()), axis=1), axis=0)
    print(counter)
    # print(lastConv_total.shape)
    print(expr.shape)

    print(f'Activations obtained')
    actsFromLastConv_1.remove()
    actsFromLastConv_2.remove()
    actsFromLastConv_3.remove()
    #actsFromPenultFC.remove()
    #actsFromLastFC.remove()
output_file.close()
print(f'File finished')

