dirs_i = dir('*6');
for i = 1:numel(dirs_i)
    tmpdir_i = dirs_i(i);
    disp(tmpdir_i.name)
    cd(tmpdir_i.name);
    dirs_j = dir('*.img');
    for j = 1:numel(dirs_j)
        
        tmpdir_j = dirs_j(j);
        disp(tmpdir_j.name)
        cd(tmpdir_j.name)
        %try
        process_fdf_folder();
        %catch
        %end
        cd ..
    end
    cd ..
end