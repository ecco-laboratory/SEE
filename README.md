# Sensory Encoding of Emotion (SEE)

#### Update: 11/21/2023

This repo contains code and instructions for performing the analyses from the paper entitled "Sensory encoding of emotion conveyed by the face and visual context" (Soderberg, Jang, & Kragel, 2023, bioRxiv). The full text manuscript can be found [here.] (BIORXIV LINK HERE)

## Repo Contents
* **scripts**: 
  - feature_extraction: this folder contains scripts that use two artificial neural networks (EmoNet and EmoFAN) to process frames of the movie 500 Days of Summer and extract features related to emotional context and facial expression, respectively
  - fitting_encoding_models: this folder contains scripts that fit encoding models for intermediate and late layers of each ANN to BOLD data from posterior STS and amygdala; prediction is measured by correlating the encoding model with the raw data
  - comparing_encoding_models: this folder contains scripts that compare the predictive results across different encoding models
  - brain_map_results: this folder contains scripts that write out encoding model results onto brain maps for each subject
* **sample_data**: this folder contains sample data for running the demo in this repository
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

## Installation Guide
MATLAB can be installed by following the instructions [here](https://www.mathworks.com/help/install/ug/install-products-with-internet-connection.html)

PyTorch can be installed by following the instructions [here](https://pytorch.org/get-started/locally/)

To install the environment using Anaconda, copy the “environment.yml” file to your directory and run the command “conda env create”

## Demo
This demo illustrates the process of fitting an encoding model for one subject based on features from EmoNet and EmoFAN and comparing it to the brain data. 

To run the demo, download the data in the sample_data folder and be sure to have the demo.m script cloned on your local machine.

The expected output is a set of matrixes that contain the prediction-outcome correlation between brain data and encoding models for a single subject (sub-1)
This includes: sub-1_pSTS_emonet_late_mean_diag_corr.mat, sub-1_pSTS_emofan_late_mean_diag_corr.mat and the beta values from the regression (beta_sub-1_pSTS_emonet_late_mean_diag_corr.mat and beta_sub-1_pSTS_emofan_late_mean_diag_corr.mat

The expected runtime is 5-10 minutes.

## Instructions for Use
1. To run the feature extraction step, download the video files (in mp4 format) from the Naturalistic Neuroimaging Database. For emonet_intermediate_500_days_of_summer.m and emonet_late_500_days_of_summer.m, update the vid_path variable to match the location in your file system before running each script. For emofan_intermediate_500_days_of_summer.py and emofan_late_500_days_of_summer.py, run convert_to_frames.py to create a folder with all of the frames of the movie. Update the test_dataset_no_flip variable to match the path in your file system before running each script.
2. To run the fiting_encoding_models step, ensure that you have the feature files and fit_encoding_model.m downloaded, and run the function fit_encoding_model(model, layer, region) with the following input options:
   >**model** - string indicating the ANN to use to extract features: ('emonet', 'emofan', or 'combined')
   >**layer** - string indicating the layers to use for analysis: ('late' or 'intermediate')
   >**region** - string indicating the ROI to predict: ('Amy' or 'STS')
3. To run the comparing_encoding_step, ensure that you have the outputs from fit_encoding_model.m for all 20 subjects before running the compare_encoding_performance.m script.
4. To run the brain_map_results step, ensure that you have the outputs from fit_encoding_model.m for all 20 subjects before running the group_inference_amygdala.m and group_inference_pSTS.m scripts.

## Pseudocode/Description of Code's Functionality
1. Feature extraction
2. Fitting encoding models
3. Comparing encoding models
4. Writing out results onto brain maps

