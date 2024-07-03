# Sensory Encoding of Emotion (SEE)

#### Update: 7/2/2024

This repo has been updated to describe additional analyses that have been added to the manuscript. These include a conceptual replication on an additional dataset ("Game of Thrones"), tests of encoding model performance in other face-processing regions, and ANN comparison analyses.

#### Update: 11/22/2023

This repo contains code and instructions for performing the analyses from the paper entitled "Sensory encoding of emotion conveyed by the face and visual context" (Soderberg, Jang, & Kragel, 2023, bioRxiv). The full text manuscript can be found [here.](https://www.biorxiv.org/content/10.1101/2023.11.20.567556v1)

## Repo Contents
* **scripts**: 
  - feature_extraction: this folder contains scripts that use two artificial neural networks (EmoNet and EmoFAN) to process frames of the movie 500 Days of Summer and extract features related to emotional context and facial expression, respfectively
  - fitting_encoding_models: this folder contains scripts that fit encoding models for intermediate and late layers of each ANN to BOLD data from posterior STS and amygdala; prediction is measured by correlating the encoding model with the raw data
  - comparing_encoding_models: this folder contains scripts that compare the predictive results across different encoding models
  - brain_map_results: this folder contains scripts that write out encoding model results onto brain maps for each subject
  - demo.m: this script performs the demo analysis, which fits encoding models using EmoNet and EmoFAN for pSTS in one subject's BOLD data
  - supplementary_analyses: this folder contains scripts that run specificity tests for ANN representations, as added in the revised manuscript
* **sample data**: sample data for the demo are available at our [OSF repository](https://osf.io/6ntx5/)
* **paper**: this folder contains documents and figures for the paper

## System Requirements

### Hardware Requirements
For minimal performance of the EmoNet and EmoFAN feature extraction steps, we recommend a computer with at least 8 GB of RAM, 32GB of SSD storage, and an Intel or AMD x86-64 processor with two or more cores.

For faster performance, MATLAB and PyTorch support NVIDIA® GPU architectures with compute capability 3.5 to 9.x.

### Software Requirements
**OS Requirements**
This software has been tested on Windows, Mac and Linux operating systems.
MATLAB Requires the following operating systems:
Windows 11 Windows 10 (version 21H2 or higher) Windows Server 2019 Windows Server 2022
Ubuntu 22.04 LTS Ubuntu 20.04 LTS Debian 11 Red Hat Enterprise Linux 9 Red Hat Enterprise Linux 8 (minimum 8.6) Red Hat Enterprise Linux 7 (minimum 7.9) SUSE Linux Enterprise Desktop 15 SUSE Linux Enterprise Server 12 (minimum SP2) SUSE Linux Enterprise Server 15
macOS Sonoma (14) macOS Ventura (13) macOS Monterey (12.6)

We have tested this code on the following operating systems:
Linux: Ubuntu 20.04 Mac: macOS Big Sur (11.5)

Code and instructions for the EmoNet model can be found at [this repository](https://github.com/ecco-laboratory/EmoNet)

Code and instructions for the EmoFAN model can be found at [this repository](https://github.com/face-analysis/emonet)
 
The EmoFAN code requires the following packages and dependencies, which are listed below and in the environment.yml file:
>channels:
>  - defaults
>  - conda-forge
>dependencies:
>  - python
>  - pandas
>  - scikit-learn
>  - numpy
>  - matplotlib
>  - IPython
>  - graphviz
>  - scikit-image=0.15.0
>  - pip
>  - pip:
>     - torch
>     - torchvision
>     - torchviz
>     - opencv-python  

Data from the Naturalistic Neuroimaging Database (Aliko et al., 2020) can be downloaded [here.](https://openneuro.org/datasets/ds002837/versions/2.0.0)

Data from the Game of Thrones study (Noad et al., In review) can be downloaded [here.](https://openneuro.org/datasets/ds004848/versions/1.0.0)

You will need to install the Canlab Core tools, as well as the Neuroimaging Pattern Masks repository, both of which are available [here.](https://canlab.github.io/_pages/canlab_help_1_installing_tools/canlab_help_1_installing_tools.html)

You will also need spm12 installed on your machine; installation [here.](https://www.fil.ion.ucl.ac.uk/spm/software/spm12/)

For supplementary analyses, data from the Karolinska Directed Emotional Faces (KDEF) database can be downloaded [here,](https://kdef.se/download-2/) and information about the stimuli from the Cowen & Keltner 2017 study is available [here.](https://www.pnas.org/doi/abs/10.1073/pnas.1702247114)

## Installation Guide
MATLAB can be installed by following the instructions [here](https://www.mathworks.com/help/install/ug/install-products-with-internet-connection.html)

PyTorch can be installed by following the instructions [here](https://pytorch.org/get-started/locally/)

To install the environment using Anaconda, copy the “environment.yml” file to your directory and run the command “conda env create”

## Demo
This demo illustrates the process of fitting an encoding model for one subject based on features from EmoNet and EmoFAN and comparing it to the brain data. 

To run the demo, download the sample data from the [OSF repository](https://osf.io/6ntx5/) and be sure to have the demo.m script cloned on your local machine.

The expected output is a set of matrices that contain the prediction-outcome correlation between brain data and encoding models for a single subject (sub-1)

This includes: sub-1_pSTS_emonet_late_mean_diag_corr.mat, sub-1_pSTS_emofan_late_mean_diag_corr.mat and the beta values from the regression (beta_sub-1_pSTS_emonet_late_mean_diag_corr.mat and beta_sub-1_pSTS_emofan_late_mean_diag_corr.mat

The expected runtime is 5-10 minutes.

## Instructions for Use
1. To run the feature extraction step, download the movie file (in .mp4 format) from the Naturalistic Neuroimaging Database. For emonet_intermediate_500_days_of_summer.m and emonet_late_500_days_of_summer.m, update the vid_path variable to match the location in your file system before running each script. For emofan_intermediate_500_days_of_summer.py and emofan_late_500_days_of_summer.py, run convert_to_frames.py to create a folder with all of the frames of the movie. Update the test_dataset_no_flip variable to match the path in your file system before running each script.
2. To run the fitting_encoding_models step, ensure that you have the feature files and fit_encoding_model.m downloaded, and run the function fit_encoding_model(model, layer, region) with the following input options:
   >**model** - string indicating the ANN to use to extract features: ('emonet', 'emofan', or 'combined')
   >**layer** - string indicating the layers to use for analysis: ('late' or 'intermediate')
   >**region** - string indicating the ROI to predict: ('Amy' or 'STS')
3. To run the comparing_encoding_step, ensure that you have the outputs from fit_encoding_model.m for all 20 subjects before running the compare_encoding_performance.m script.
4. To run the brain_map_results step, ensure that you have the outputs from fit_encoding_model.m for all 20 subjects before running the group_inference_amygdala.m and group_inference_pSTS.m scripts.

## Pseudocode/Description of Code's Functionality
1. Feature extraction:
   - **convert_to_frames.py** reads the 500 Days of Summer movie file (in .mp4 format) and saves each frame as an image to the “frames” directory
   - **emofan_intermediate_500_days_of_summer.py** extracts the activations from an intermediate layer of EmoFAN. To do this, it creates a “dataloader” object that contains all of the frames from the movie. Next, it loads EmoFAN using PyTorch. Then it sets up “hooks” to capture the activations from the final convolutional layer (in EmoFAN’s structure, this layer has three subblocks, so each block is hooked and they are concatenated). Then, it loops through the frames of the movie and as each image is fed through the ANN, the activations get saved to an output file.
   - **emofan_late_500_days_of_summer.py** performs the same steps as above, but saves out the activations for the final layer of the ANN.
   - **emonet_intermediate_500_days_of_summer.m** extracts the activations from an intermediate layer of EmoNet. To do this, it loads the EmoNet model and specifies layer fc7 to be extracted. It then loops through the movie file, and for every fifth frame, reads the image and passes it to the ANN. For each image, activations from layer fc7 are extracted and saved to an output file.
   - **emonet_late_500_days_of_summer.m** performs the same steps as above, but saves out the activations for the final layer of the ANN (fc8).
   - In the **supplementary** folder, versions of the above scripts extract features from the Study 2 stimulus (a compilation of clips from the show Game of Thrones, see Noad et al.)
2. Fitting encoding models
   - **fit_encoding_model.m** is a function that uses the activations extracted above to create encoding models to predict brain activity. To do this, it first loads the features of the ANN (specified as an input with either “emonet”, “emofan”, or “combined”.) Then, it loops through all subjects in the dataset (n=20). For each subject, BOLD data from the movie is loaded and masked with the region of interest (specified as an input with either “Amy” or “pSTS”). Then, the features from the ANN are resampled to match the BOLD data, and are convolved to match the timing of the hemodynamic response function. Next, PLS regression is performed using the features as predictors and the BOLD data as outcome, with the dimensionality of the PLS regression model specified by the “dim” variable (10 for EmoFAN, 20 for EmoNet and combined). Then, the noise ceiling for this prediction is estimated by resubstitution: multiplying the original BOLD data by the betas and comparing the result to the original BOLD data. Next, five-fold cross-validation is used to perform PLS regression on 4/5 of the data; the model is tested on the remaining 5th of the data. The prediction from this model is correlated with the original BOLD data to get an estimate of performance. The diagonal of the correlation matrix is averaged across folds, and saved for each subject. Finally, the noise ceiling estimation is saved for all subjects.
   - **fit_encoding_model_lateralization.m** performs the same steps as the main fit_encoding_model.m script, but predicts brain activity separately for left and right portions of each region.
   - **fit_encoding_model_supplementary.m** performs the same steps as the main fit_encoding_model.m script for Study 2. 
3. Comparing encoding models
   - **compare_encoding_performance.m** computes ANOVAs to compare the performance of encoding models in Study 1 across model, region, and depth. To do this, it loads in the prediction metric (the correlation between encoding model prediction and BOLD data) for each subject. In addition, it computes the percent noise ceiling based on the noise ceiling estimated by resubstitution. It plots performance across all combinations of the variables (model: EmoFAN, EmoNet, combined; region: amygdala, pSTS; depth: intermediate, late). Next, a two-way ANOVA is performed testing the effects of region and model in the late layers (2 by 3). Next, the same region by model two-way ANOVA is performed for the intermediate layers. Next, a three-way ANOVA is performed testing the effects of region, depth, and model (2 by 2 by 3). Finally, two two-way ANOVAs are performed testing the effects of model and depth separately for the amygdala and pSTS. Performance levels are plotted with box and rain cloud plots.
   - **compare_encoding_performance_lateralization.m** computes raw prediction-outcome correlation and percent noise ceiling for each hemisphere, model, region, and depth combination, and performs t-tests to compare performance in left vs. right.
   - **compare_encoding_performance_supplementary.m** performs the same tests of performance as "compare_encoding_performance.m", for Study 2 (Game of Thrones).
   - **make_summary_csv.m** and **make_summary_csv_supplementary.m** combine encoding model performance results into an array and write it to a csv file, for Study 1 and Study 2 respectively.
   - **updated_model_comparisons_faceRegions.m** loads encoding model results from additional face regions (FFA, OFA), plots them, and compares them to pSTS performance.
4. Brain map results
   - **group_inference_pSTS.m** performs voxelwise inference on model performance across subjects. To do this, it loads the prediction metric for each subject. Then, it performs t-tests on model performance comparing each encoding model’s performance to 0. In addition, a t-test comparing EmoNet to EmoFAN is performed. Finally, a t-test comparing the combined model to both EmoNet and EmoFAN is performed. The statistic maps are written out in brain space as a nifti file. 
   - **group_inference_amygdala.m** performs the same steps as above, but for model performance in amygdala. Because of differential subcortical coverage during data collection, not all subjects had all amygdala voxels, so non overlapping voxels were excluded from the analysis.
5. Supplementary analyses:
   - **correlate_yhats_allFaceRegions.m** compares Study 1 model predictions across regions in the face processing network (FFA, OFA, pSTS, Amygdala) and plots these relationships.
   - **EmoFAN_on_CowenKeltner.m** as part of the specificity analysis, this script uses representations from the late layer of EmoFAN to classify the emotion categories of visual scenes from the Cowen & Keltner 2017 study.
   - **EmoNet_on_CowenKeltner.m** as part of the specificity analysis, this script uses representations from the late layer of EmoNet to classify the emotion categories of visual scenes from the Cowen & Keltner 2017 study.
   - **EmoFAN_on_KDEF.m** as part of the specificity analysis, this script uses representations from the late layer of EmoFAN to classify the emotion expression categories from the Karolinska Directed Emotional Faces Dataset.
   - **EmoNet_on_KDEF.m** as part of the specificity analysis, this script uses representations from the late layer of EmoNet to classify the emotion expression categories from the Karolinska Directed Emotional Faces Dataset.
   - **feature_visualization.m** examines features from the encoding models based on each ANN, performing correlations across layers and models and visualizing features using t-stochastic neighbor embedding (tSNE).

