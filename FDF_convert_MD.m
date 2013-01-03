function FDF_convert_MD

%% FDF TO NIFTI CONVERTER

%   by Mike Debney

%   Converts varian FDF data to raw nifti image file

%   OUTPUTS:
  
%   MD_nifti.nii = 4D Nifti file of dimensions x,y,z,g
%   bvecs = ascii bvecs file
%   bvals = ascii bvals file

%%  USAGE NOTES

%   UI Prompt(1): Number of grad directions, data type, averages

%   Files need to be stored with one single average in entire directory;
%   code can distinguish whether conventional or external recon
%   processing (default = 1)

%   After file is selected; next UI is directory which contains folders
%   with other averages (usually two up from first UI)

%   HDR data read from first average only; generates bvals, bvecs and
%   parameters for reading *.img file

%   IMG data read from all averages into cell array, averaged, then output
%   to nifti

%   UI Prompt(2): Voxel size, Output Directory & Filename

%% CODING NOTES

%   Optimised for Mac (Windows; need to change direction of '\' to '/')
%   External recon IMG data NOT YET SUPPORTED

%% CODE
clc
clear all

% UI Parameters

prompt = {'Enter No. of Gradient Directions (exc b0):', 'Conventional (1) or External Recon (2) data?','Number of Averages?'};
name = 'Input for Header Reader';
numlines = 1;
defaultanswer={'30','1','6'};

parameters = inputdlg(prompt,name,numlines,defaultanswer);

g = str2num(cell2mat(parameters(1)));
order = str2num(cell2mat(parameters(2)));
averages = str2num(cell2mat(parameters(3)));


% Choose Initial File & Set Root Directory (containing averages)

[filename, pathname] = uigetfile('*.fdf');           % Choose filename (same across all averages)
dirname = uigetdir(pathname,'Choose x');             % Choose root directory (where all averages kept) 
c= dir(dirname);                                     % Creates list of ALL folders/files within root directory
no_objects= size(c,1);                               % Number of objects (files/folders) in directory

a = cell([],[]);                                     % Pre-allocated empty cell

for i = 1:no_objects
    if strncmp('epip',c(i).name,4)                   % Search loop to extract all files/folders with epip in
        a{i} = c(i).name;                            % Put answer in empty cell a
    else
    end
end

a = a(~cellfun('isempty',a));                        % Remove empty erroneous values from a

if averages ~= size(a,2);                            % Averages error check
    msgbox('Inconsistent Number of Averages; check root directory')
    clear
else
end

fdf_dir = cell([],[]);
path = cell([],[]);

for n = 1:averages
    
    path{n} = [dirname, '/', char(a(n))];    % Create cell of all file paths
    fdf_dir{n} = dir(char(path(n)));         % Create cell struct of each file path
    
end

fdf_number = length(fdf_dir{:,1});           % Should at some point put in check loop to ensure each averages set == number of files
fdf_no = fdf_number-2;

% Read HDR Strings (from all hdrs of initial directory only) 

if mod(fdf_no,(g+1))==0     % Checks that number of files divisble by number of gradient directions
    start = 3;              % If so; assumes only fdf files in dir (plus . & ..)
else
    start = 4;              % If not; starts at 2nd file (assume 1st is procpar)
end

if order ==1;
    for n=start:fdf_number
    filename = fdf_dir{1,1}(n).name;
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
   for n=start:fdf_number
    filename = fdf_dir{1,1}(n).name;
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

for n=start:fdf_number
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


% Read *.img Data

file = cell([],[]);
img = cell([],[]);
    
    for k = 1:fdf_number
        for n = 1:averages
            file{k} = fdf_dir{1,n}(k).name;                              % Loops through ALL files in directory
                if strncmp('slice0', file{k},6)                          % Only opens files with 'slice0' i.e. fdf
                    fid = fopen([char(path(n)) '/' char(file{k})],'r');
                    skip = fseek(fid, -S*S*bits/8, 'eof');
                    img{n}(k).nii = fread(fid, [S, S],'float32', machineformat);
                    fclose(fid);
                else
                end
        end
    end

clear file
clear fdf_no
clear fdf_dir
clear a
clear c 

img2 = cell2mat(img);
img2 = struct2cell(img2);
img2 = reshape(img2,(fdf_number*averages),1);
img2 = img2(~cellfun('isempty',img2));
img2 = reshape(img2,(size(img2,1)/averages), averages);

clear img

img3 = cell([],[]);
test4 = cell([],[]);            % Empty array to be filled with averaged 128x128 values

for j = 1:size(img2,1)
      img3{j} = cell2mat(img2(j,:));                            % Create new cell array with each cell containing all values for all averages
      img3{j} = reshape(cell2mat(img3(j)), (S*S),averages);     % Reshape (128*128) each cell to a 6 columns
      img4 = cell2mat(img3(j));                                 % Convert each column to matrix
      img4 = mean(img4,2);                                      % Take mean for each row (from 6 columns)
      img4 = reshape(img4,S,S);                                 % Reshape back into 128 by 128 matrix
      test4{j} = img4;                                          % Put matrix back into cell array
end

clear img2
clear img3
clear img4

% Generate Averaged *.img File    

img = cell2mat(test4);                      % Convert to matrix
img = reshape(img,S,S,(g+1),slices);        % Reshape (this is correct)
img = permute(img,[1,2,4,3]);               % Reorder (this is correct)


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

% % Test Image Show
% 
% img2 = img(:,:,20,1);
% img_2 = img2';
% figure;
% imshow(img_2, []); 
% colormap(gray);
% axis image;
% axis off;
end


