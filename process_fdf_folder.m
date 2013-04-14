function [img, hdr, bvals, bvecs] = process_fdf_folder(dirname,output)
% PROCESS_FDF_FOLDER converts Varian FDF.img folder to nifti
%
% Usage: [img, hdr, bvals, bvecs] = process_fdf_folder(dirname,output)
%
%   dirname is the full path to a Varian fdf .img folder.
%   output (optional) is a name to call the nifti output, otherwise the
%   output filename defaults to the sequence and study id as in the varian
%   header.
%
%   img is a matrix of the fdf image data.
%   hdr is the header of the fdf image (converted using parse_fdf_header)
%   bvals is a vector of gradient weights
%   bvecs is a matrix of gradient directions
%
% Requires Tools for NifTi and ANALYZE Image http://www.mathworks.co.uk/matlabcentral/fileexchange/8797
%
% Author:
% Peter Hellyer - Imperial College London (peter.hellyer10@imperial.ac.uk)

if nargin < 1
    %assume the current directory if no arg given
    dirname = pwd;
end
img=[];
%scroll through images
images = dir('*.fdf');
for imno = 1:numel(images)
    %load image in
    tmp = images(imno);
    fullname = sprintf('%s%c%s',dirname,'/',tmp.name);
    [tmp, hdr] = load_fdf(fullname);
    switch hdr.rank
        case 3
            %we're probably looking at a slab not a slice.
            img(1:hdr.matrix(1),1:hdr.matrix(2),1:hdr.matrix(3)) =tmp;
        otherwise
            img(1:hdr.matrix(1),1:hdr.matrix(2),hdr.slice_no,hdr.array_index) = tmp;
    end
    bvals(hdr.array_index) = hdr.bvalue;
    bvecs(hdr.array_index,1) = hdr.dro;
    bvecs(hdr.array_index,2) = hdr.dpe;
    bvecs(hdr.array_index,3) = hdr.dsl;
end
nii = make_nii(img);
%set orientation
nii.hdr.hist.srow_x = [hdr.orientation(1:3) 1];
nii.hdr.hist.srow_y = [hdr.orientation(4:6) 1];
nii.hdr.hist.srow_z = [hdr.orientation(6:9) 1];
nii.hdr.dime.pixdim(2) = hdr.roi(1)/10;
nii.hdr.dime.pixdim(3) = hdr.roi(2)/10;
nii.hdr.dime.bitpix=hdr.bits;
if hdr.bits == 32
nii.hdr.dime.datatype=16;
end
switch hdr.rank
    case 2
      nii.hdr.dime.pixdim(4) = hdr.roi(3)*10;  
    otherwise
nii.hdr.dime.pixdim(4) = hdr.roi(3)/10;
end
%set dimension
if nargin < 2
    %if no output filename is given, make one up from the header.
    output = [hdr.sequence '_' hdr.studyid];
end
%nii.hdr.dime.datatype=hdr.bits;
%nii.hdr.dime.bitpix=hdr.bits;
save_nii(nii,[output '.nii']);
system(['gzip ' output '.nii']);