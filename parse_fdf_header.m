function hdr = parse_fdf_header(im_hdr)
% PARSE_FDF parses the header as read from an fdf file.
%
% Usage: hdr = parse_fdf_header(im_hdr)
%
%   im_hdr is a cell array of an fdf header where each cell is a line of
%   the header
%
%   Outputs a structure hdr, containing the entire header
%
% Author:
% Peter Hellyer - Imperial College London (peter.hellyer10@imperial.ac.uk)

hdr.bvalue= 0;
hdr.dro=0;
hdr.dpe=0;
hdr.dsl=0;
%loop through headers
for i = 1:numel(im_hdr)
    if numel(im_hdr{i}) > 4
        % clean up the header for ease of conversion.
        a = strrep(im_hdr{i},', ',',');
        a = strrep(a,'[]','');
        a = strrep(a,'{ "','{"');
        a = strrep(a,'" }','"}');
        a = strrep(a,'{','[');
        a = strrep(a,'}',']');
        
        a=textscan(a,'%s');
        a = a{1};
        %type = a{1};
        field = a{2};
        field = strrep(field,'*','');
        
        
        value = a{4};
        
        value = strrep(value,'"','''');
        %trim off the ;
        value = value(1:end-1);
        eval(['hdr.' field ' = ' value ';']);
    end
end