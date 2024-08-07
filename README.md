# eeglab_scripts
This repository contains scripts to make EEG preprocessing faster/easier, using EEGLab via Matlab 


# MATLAB Scripts
- processEEGDataToCSV_Regional.m : For finding regional EEG values (different brain regions). Script that runs the overall process, and calls all the other functions needed for the process. This is the one you type into the MATLAB command line
- processEEGDataToCSV_Global.m : For finding global EEG values (across whole brain). Script that runs the overall process, and calls all the other functions needed for the process. This is the one you type into the MATLAB command line
- CalculateGlobalPower.m : does Fast Fourier Transform, calculates power spectral densities across whole brain with the following frequency bands - delta (1-3 hz), theta (4-7 hz), alpha (8-12 hz), beta (13-24 hz)
- epochAndCalculatePSD.m : does Fast Fourier Transform, calculates power spectral densities across different regions with the following frequency bands - delta (1-3 hz), theta (4-7 hz), alpha (8-12 hz), beta (13-24 hz)
- bandPower.m : contributes to the process of finding specific power values within each frequency band; finds indices of frequencies within each band, and then sums the power spectral density values, multiplies by the frequency resolution, then averages it across channels within the area designated (can be a region or global)



# RStudio Scripts
- Number_Indicing.Rmd : Used to find the new indices of regional channels for EEG files where certain electrodes are removed. First set the original number indices for each region (designating which electrodes belong to each region), then for the variable "numbers_to_remove", put in the indices of the channels you have removed, and the code will output the new indices for each region, adjusted for the removed channels 
