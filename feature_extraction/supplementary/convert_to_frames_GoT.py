import imageio
filename = '/home/data/eccolab/Code/NNDb/SEE/feature_extraction/supplementary/GameofThronesv1.mov'
vid = imageio.get_reader(filename)
outpath = '/home/data/eccolab/Code/NNDb/SEE/feature_extraction/supplementary/GoT_frames'
#os.mkdir(outpath)

c = 0
for image in vid.iter_data():
    c += 1
    print(image.mean())
    imageio.imwrite("{}/{}.png".format(outpath,c), image)

