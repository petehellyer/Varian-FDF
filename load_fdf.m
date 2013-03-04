function [img,hdr] = load_fdf(filename)
% LOAD_FDF converts a varian fdf file.
%
% Usage: [img,hdr] = load_fdf(filename)
%
%   filename is the full path to a Varian fdf file.
%
%   img is a matrix of the fdf image data.
%   hdr is the header of the fdf image (converted using parse_fdf_header)
% 
% Adapted from Varian MRI FDF Reader by Shanrong Zhang - http://www.mathworks.co.uk/matlabcentral/fileexchange/7449-varian-mri-fdf-reader
%
% Author:
% Peter Hellyer - Imperial College London (peter.hellyer10@imperial.ac.uk)


warning off MATLAB:divideByZero;

[fid] = fopen([filename],'r');

num = 0;
done = false;
machineformat = 'ieee-be'; % Old Unix-based
line = fgetl(fid);
while (~isempty(line) && ~done)
    line = fgetl(fid);
    % disp(line)
    hdr{num+1} = line;
    num = num + 1;
    
    if num > 45
        done = true;
    end
end
hdr = parse_fdf_header(hdr);
if hdr.bigendian == 0
    machineformat = 'ieee-le';
end
bits = hdr.bits;
M(1) = hdr.matrix(1);
M(2) = hdr.matrix(2);
if hdr.rank == 3
    M(3) = hdr.matrix(3);
    skip = fseek(fid, -M(1)*M(2)*M(3)*bits/8, 'eof');
    img = fread(fid, [M(1)* M(2), M(3)], 'float32', machineformat);
    img = reshape(img,M(1),M(2),M(3));
else
    skip = fseek(fid, -M(1)*M(2)*bits/8, 'eof');
    
    img = fread(fid, [M(1), M(2)], 'float32', machineformat);
end

fclose(fid);