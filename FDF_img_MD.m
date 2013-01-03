%% FDF HEADER READER

% Code which reads in directory of FDF files and outputs entire header
% structure to fid_header

% INPUTS
% UI box - Number of Gradient directions
% UI box - Order of data (conventional or external recon) 

% OUTPUS 
% bvecs 
% bvals 

%% CODE
clc
clear all

% UI Parameters

prompt = {'Enter No. of Gradient Directions (exc b0):', 'Conventional (1) or External Recon (2) data?','Number of Averages?'};
name = 'Input for Header Reader';
numlines = 1;
defaultanswer={'30','1','5'};

parameters = inputdlg(prompt,name,numlines,defaultanswer);

g = str2num(cell2mat(parameters(1)));
order = str2num(cell2mat(parameters(2)));
averages = str2num(cell2mat(parameters(3)));

% UI Select 1st FDF file (reads entire directory) Order independent

[filename, pathname] = uigetfile('*.fdf','Please select a fdf file');
fdf_dir = dir(pathname);
fdf_dir = fdf_dir(3:end);
fdf_no = length(fdf_dir);

% Load HDR Strings

if mod(fdf_no,(g+1))==0     % Checks that number of files divisble by number of gradient directions
    start = 1;              % If so; assumes only fdf files in dir
else
    start = 2;               % If not; starts at 2nd file (assume 1st is procpar)
end

if order == 1
    for n=start:fdf_no
    filename = fdf_dir(n).name;
    [fid] = fopen([pathname filename],'r');
    fid_header.hdr04{n} = fgetl(fid);
    fid_header.floatrank{n} = fgetl(fid);
    fid_header.spacialrank{n} = fgetl(fid);
    fid_header.storage{n} = fgetl(fid);
    fid_header.floatbits{n} = fgetl(fid);
    fid_header.chartype{n} = fgetl(fid);
    fid_header.floatmatrix{n} = fgetl(fid);
    fid_header.charabscissa{n} = fgetl(fid);
    fid_header.charordinate{n} = fgetl(fid);
    fid_header.floatspan{n} = fgetl(fid);
    fid_header.floatorigin{n} = fgetl(fid);
    fid_header.charnucleus{n} = fgetl(fid);
    fid_header.nucfreq{n} = fgetl(fid);
    fid_header.location{n} = fgetl(fid);
    fid_header.roi{n} = fgetl(fid);
    fid_header.gap{n} = fgetl(fid);
    fid_header.filepath{n} = fgetl(fid);
    fid_header.slice_no{n} = fgetl(fid);
    fid_header.slices{n} = fgetl(fid);
    fid_header.echo_no{n} = fgetl(fid);
    fid_header.echoes{n} = fgetl(fid);
    fid_header.TE{n} = fgetl(fid);
    fid_header.te{n} = fgetl(fid);
    fid_header.TR{n} = fgetl(fid);
    fid_header.tr{n} = fgetl(fid);
    fid_header.ro_size{n} = fgetl(fid);
    fid_header.pe_size{n} = fgetl(fid);
    fid_header.seq{n} = fgetl(fid);
    fid_header.studyid{n} = fgetl(fid);
    fid_header.pos1{n} = fgetl(fid);
    fid_header.pos2{n} = fgetl(fid);
    fid_header.TI{n} = fgetl(fid);
    fid_header.ti{n} = fgetl(fid);
    fid_header.array_index{n} = fgetl(fid);
    fid_header.array_dim{n} = fgetl(fid);
    fid_header.image{n} = fgetl(fid);
    fid_header.display_order{n} = fgetl(fid);
    fid_header.bigendian{n} = fgetl(fid);
    fid_header.imagescale{n} = fgetl(fid);
    fid_header.psi{n} = fgetl(fid);
    fid_header.phi{n} = fgetl(fid);
    fid_header.theta{n} = fgetl(fid);
    fid_header.orientation{n} = fgetl(fid);
    fid_header.image2{n} = fgetl(fid);          % Extra Line
    fid_header.dro{n} = fgetl(fid);
    fid_header.dpe{n} = fgetl(fid);
    fid_header.dsl{n} = fgetl(fid);
    fid_header.bvalue{n} = fgetl(fid);
    fid_header.checksum{n} = fgetl(fid);
    fid_header.blank{n} = fgetl(fid);          % Blank
    fid_header.blank2{n} = fgetl(fid);         % Blank
    fclose(fid);
    end
else
   for n=start:fdf_no
    filename = fdf_dir(n).name;
    [fid] = fopen([pathname filename],'r');
    fid_header.hdr{n} = fgetl(fid);
    fid_header.hdr02{n} = fgetl(fid);
    fid_header.blank{n} = fgetl(fid);
    fid_header.hdr04{n} = fgetl(fid);
    fid_header.floatrank{n} = fgetl(fid);
    fid_header.spacialrank{n} = fgetl(fid);
    fid_header.storage{n} = fgetl(fid);
    fid_header.floatbits{n} = fgetl(fid);
    fid_header.chartype{n} = fgetl(fid);
    fid_header.floatmatrix{n} = fgetl(fid);
    fid_header.charabscissa{n} = fgetl(fid);
    fid_header.charordinate{n} = fgetl(fid);
    fid_header.floatspan{n} = fgetl(fid);
    fid_header.floatorigin{n} = fgetl(fid);
    fid_header.charnucleus{n} = fgetl(fid);
    fid_header.nucfreq{n} = fgetl(fid);
    fid_header.location{n} = fgetl(fid);
    fid_header.roi{n} = fgetl(fid);
    fid_header.gap{n} = fgetl(fid);
    fid_header.filepath{n} = fgetl(fid);
    fid_header.slice_no{n} = fgetl(fid);
    fid_header.slices{n} = fgetl(fid);
    fid_header.echo_no{n} = fgetl(fid);
    fid_header.echoes{n} = fgetl(fid);
    fid_header.TE{n} = fgetl(fid);
    fid_header.te{n} = fgetl(fid);
    fid_header.TR{n} = fgetl(fid);
    fid_header.tr{n} = fgetl(fid);
    fid_header.ro_size{n} = fgetl(fid);
    fid_header.pe_size{n} = fgetl(fid);
    fid_header.seq{n} = fgetl(fid);
    fid_header.studyid{n} = fgetl(fid);
    fid_header.pos1{n} = fgetl(fid);
    fid_header.pos2{n} = fgetl(fid);
    fid_header.TI{n} = fgetl(fid);
    fid_header.ti{n} = fgetl(fid);
    fid_header.array_index{n} = fgetl(fid);
    fid_header.array_dim{n} = fgetl(fid);
    fid_header.image{n} = fgetl(fid);
    fid_header.display_order{n} = fgetl(fid);
    fid_header.bigendian{n} = fgetl(fid);
    fid_header.imagescale{n} = fgetl(fid);
    fid_header.psi{n} = fgetl(fid);
    fid_header.phi{n} = fgetl(fid);
    fid_header.theta{n} = fgetl(fid);
    fid_header.orientation{n} = fgetl(fid);
    fid_header.dro{n} = fgetl(fid);
    fid_header.dpe{n} = fgetl(fid);
    fid_header.dsl{n} = fgetl(fid);
    fid_header.bvalue{n} = fgetl(fid);
    fid_header.checksum{n} = fgetl(fid);
    fid_header.filename{n} = fgetl(fid);
    fid_header.creation{n} = fgetl(fid);
    fid_header.user{n} = fgetl(fid);
    fid_header.hostname{n} = fgetl(fid);
    fclose(fid);
   end  
end

% Convert Chars to Strings (could be done in loop)
% Add additional as needed

[fid_header.psi] = strtok(fid_header.psi,'float  psi[] = { , };');
[fid_header.phi] = strtok(fid_header.phi,'float  phi[] = { , };');
[fid_header.theta] = strtok(fid_header.theta,'float  theta[] = { , };');
[fid_header.dro] = strtok(fid_header.dro,'float  dro[] = { , };');
[fid_header.dpe] = strtok(fid_header.dpe,'float  dpe[] = { , };');
[fid_header.dsl] = strtok(fid_header.dsl,'float  dsl[] = { , };');
[fid_header.bvalue] = strtok(fid_header.bvalue,'float  bvalue[] = { , };');

if order ==1;
[fid_header.slices] = strtok(fid_header.slices,'int  slices[] = { , };');
else
[fid_header.slices] = strtok(fid_header.slices,'float  slices[] = { , };');
end 

slices = str2num(cell2mat(fid_header.slices(start)));          % Slices constant across all fdfs; take just 1st

% Convert Strings (in cells) to Matrices
% Add additional as needed

for n=start:fdf_no
    dro(n) = str2num(cell2mat(fid_header.dro(n)));
    dpe(n) = str2num(cell2mat(fid_header.dpe(n)));
    dsl(n) = str2num(cell2mat(fid_header.dsl(n)));
    bvals(n) = str2num(cell2mat(fid_header.bvalue(n)));
end

% Reduce to size of number of fdf files

dro = dro(start:end);
dpe = dpe(start:end);
dsl = dsl(start:end);
bvals = bvals(start:end);

% Reshape & Check for Vector differences
if order == 1;
    x = reshape(dro, [(g+1) slices]);
    y = reshape(dpe, [(g+1) slices]);
    z = reshape(dsl, [(g+1) slices]);
    x_d = diff(x,[],2);
    y_d = diff(y,[],2);
    z_d = diff(z,[],2);

    if all(x_d ==0)
        'go'
        bvecs(:,1) = x(:,1);
    else
        error('B-Vec file corrupt')
    end

    if all(y_d ==0)
        'go'
        bvecs(:,2) = y(:,1);
    else
        error('B-Vec file corrupt')
    end
    
    if all(z_d ==0)
        'go'
        bvecs(:,3) = z(:,1)
    else
        error('B-Vec file corrupt')
    end
    
    bvals = reshape(bvals, [(g+1) slices]);
    bvals = bvals(:,1)
    
else
    x = reshape(dro, [slices (g+1)]);
    y = reshape(dpe, [slices (g+1)]);
    z = reshape(dsl, [slices (g+1)]);
    x_d = diff(x);
    y_d = diff(y);
    z_d = diff(z);
    
    if all(x_d ==0)
        'go'
        bvecs(:,1) = x(1,:);
    else
        error('B-Vec file corrupt')
    end

    if all(y_d ==0)
        'go'
        bvecs(:,2) = y(1,:);
    else
        error('B-Vec file corrupt')
    end
    
    if all(z_d ==0)
        'go'
        bvecs(:,3) = z(1,:)
    else
        error('B-Vec file corrupt')
    end
    
    bvals = reshape(bvals, [slices (g+1)]);
    bvals = flipud(rot90(bvals(1,:)))
end


% Find Dimensionality of Slice

if strncmp('float  matrix[] =', fid_header.floatmatrix(start),10)
        [token, rem] = strtok(fid_header.floatmatrix(start),'float   matrix[] = { , };');
        S = str2double(cell2mat(token));
end

% Find Number of Bits

if strncmp('float  bits = ', fid_header.floatbits(start),10)
        [token, rem] = strtok(fid_header.floatbits(start),'float   bits = { , };');
        bits = str2double(cell2mat(token));
end


% Check Machine Data Format

if strncmp('int    bigendian = 0',fid_header.bigendian(start),15)
    machineformat = 'ieee-le'; % New Linux-based  
else 
    machineformat = 'ieee-be';
end


% Preallocate Cells

if mod(fdf_no,(g+1))==0          % Checks that number of files divisble by number of gradient directions
    start_file = 1;              % If so; assumes only fdf files in dir
else
    start_file = 2;              % If not; starts at 2nd file (assume 1st is procpar)
end

filename = cell(fdf_no-start_file+1,[]);
img = cell(fdf_no-start_file+1,[]);

% Loop to Open all fdf Files in Directory

for k = 1:fdf_no
    filename{k} = fdf_dir(k).name;                              % Loops through ALL files in directory
    if strncmp('slice0', filename{k},6)                         % Only opens files with 'slice0' i.e. fdf
        fopen([pathname filename{k}],'r');
        skip = fseek(fid, -S*S*bits/8, 'eof');
        img{k} = fread(fid, [S, S],'float32', machineformat);
        fclose(fid);
    else
    end
end

img = img(~cellfun('isempty',img));         % Remove any empty arrays (created in else field above from procpar)
img = cell2mat(img);                        % Convert to matrix
img = reshape(img,S,(g+1),slices,S);        % Reshape (this is correct)
img = permute(img,[1,4,3,2]);               % Reorder (this is correct)


% Output Nifti File

prompt = {'Voxel Size: x:', 'Voxel Size: y:','Voxel Size: z:','Save to Directory:','Filename'};
name = 'NIFTI Output';
numlines = 1;
defaultanswer={'1','1','2.5',uigetdir,'nifti_MD.nii'};

nii_paras = inputdlg(prompt,name,numlines,defaultanswer);

vox_x = str2num(cell2mat(nii_paras(1)));
vox_y = str2num(cell2mat(nii_paras(2)));
vox_z = str2num(cell2mat(nii_paras(3)));
save_dir = char(nii_paras(4));
save_fil = char(nii_paras(5));

img_nii = make_nii(img, [vox_x vox_y vox_z]);          % Haven't bothered putting HDR information in here

save_nii(img_nii,[save_dir save_fil]);
save([save_dir 'bvals'], 'bvals', '-ascii');
save([save_dir 'bvecs'], 'bvecs', '-ascii');



% % Plot Check
% % 
img2 = img(:,:,20,1);
img_2 = img2';
figure;
imshow(img_2, []); 
colormap(gray);
axis image;
axis off;

