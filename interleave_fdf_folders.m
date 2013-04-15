function [img, hdr] = interleave_fdf_folders(foldera,folderb,output,nosave)
%This is probably not a common thing to do. I've included it for completeness of our methods though
%This function Interleaves slices of two fdf folder aquisitions (and averages the associated bvals
%and bvecs, incase this is a problem.)
if nargin < 3
    %assume the current directory if no arg given
    output = pwd;
end
if nargin < 4
    %automatically force output
    nosave = false;
end

%import two folders of images
[img_a, hdr_a, bvals_a, bvecs_a] = convert_fdf_folder(foldera,output,true);
[img_b, hdr_b, bvals_b, bvecs_b] = convert_fdf_folder(folderb,output,true);

%take the mean of the bvals and bvecs (probably sensible?!)
bvals = (bvals_a+bvals_b)./2;
bvecs = (bvecs_a+bvecs_b)./2;
if size(img_a) ~= size(img_b)
    error('Image dimensions are wrong, not possible to interleave');
end
img = zeros([size(img_a,1),size(img_a,2),(size(img_a,3)+size(img_b,3)),size(img_a,4)]);
for i = 1:size(img_a,3);
    img(:,:,(i*2)-1,:) = img_a(:,:,i,:);
    img(:,:,(i*2),:) = img_b(:,:,i,:);
end
%assuming that the headers are on the whole identical.
hdr = hdr_a;

if nosave == false
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
    if nargin < 3
        %if no output filename is given, make one up from the header.
        output = [hdr.sequence '_' hdr.studyid];
    end
    %check if there are any bvals and bvecs to save.
    if exist('bvals','var') && exist('bvecs','var')
        if numel(bvals)>0 && numel(bvecs)>0
            %format and save to file.
            %this will be in FSL format
            %(see: http://fsl.fmrib.ox.ac.uk/fsl/fslwiki/FDT/UserGuide#DTIFIT)
            save([output '_bvecs'], 'bvecs', '-ascii');
            save([output '_bvals'], 'bvals', '-ascii');
        end
    end
    %save out a nifti image.
    save_nii(nii,[output '.nii']);
    system(['gzip ' output '.nii']);
end