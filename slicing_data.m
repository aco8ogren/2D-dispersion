clear; close all;
% Needs to be updated for OOP
% Should re-write this to load a DispersionDataset object, select a subset
% of the dispersion dataset, and then save the new (smaller) DispersionDataset object
% in a new location

data = load(['C:\Users\alex\OneDrive - California Institute of Technology\Documents\Graduate\Research\2D-dispersion\OUTPUT\'...
    'N_pix4x4 N_ele2x2 N_wv101x51 N_disp10000 N_eig20 offset0 output 11-Jun-2021 13-24-45\DATA N_wv101x51 N_disp10000 RNG_offset0 11-Jun-2021 13-24-45.mat']);

EIGENVALUE_DATA = data.EIGENVALUE_DATA(:,:,1:100);
WAVEVECTOR_DATA = data.WAVEVECTOR_DATA(:,:,1:100);

output_folder = ['C:\Users\alex\OneDrive - California Institute of Technology\Documents\Graduate\Research\2D-dispersion\OUTPUT\N_pix4x4 N_ele2x2 N_wv101x51 N_disp10000 N_eig20 offset0 output 11-Jun-2021 13-24-45\'];

save([output_folder 'DATA N_wv101x51 N_disp100 offset0 11-Jun-2021 13-24-45'],'EIGENVALUE_DATA','WAVEVECTOR_DATA') 
