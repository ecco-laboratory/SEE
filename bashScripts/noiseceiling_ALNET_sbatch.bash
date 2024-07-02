#!/bin/bash
#SBATCH --account=default
#SBATCH --partition=day-long
#SBATCH --nodelist=node1
#SBATCH -n 1
#SBATCH --time=0-12:00:00
#SBATCH --mem=60GB
​
module load MatlabR2022a
matlab -nodisplay -nosplash -nodesktop -r "cd('/home/data/eccolab/Code/NNDb/SEE');predict_amygdala_activity_emonet_late_resub; exit;"
