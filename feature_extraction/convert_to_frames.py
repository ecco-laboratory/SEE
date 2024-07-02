import os
import imageio
filename = '/home/data/eccolab/OpenNeuro/ds002837/stimuli/500_days_of_summer.mp4'
vid = imageio.get_reader(filename,  'ffmpeg')
outpath = '/home/data/eccolab/OpenNeuro/ds002837/stimuli/500_days_of_summer/frames'
#os.mkdir(outpath)

c = 0
for image in vid.iter_data():
    c += 1
    print(image.mean())
    imageio.imwrite("{}/{}.png".format(outpath,c), image)

