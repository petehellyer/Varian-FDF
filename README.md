Varian-FDF Readers
=================

Matlab code to read varian FDF files

Makes use of nifti-tools (http://www.mathworks.co.uk/matlabcentral/fileexchange/8797) save_nii and make_nii to generate outputs

<b> FDF_hdr_MD

Reads hdr information from single directory of FDF files
Generates bvals, bvecs

<b> FDF_img_MD

Reads hdr & img data from single directory (one average) of FDF file
Generates bvals, bvecs & nifti (img) file

<b> FDF_convert_MD

Reads multiple user-specified directories of FDF files to generate averaged nifti file
Generates bvals, bvecs & average nifti (img) file

