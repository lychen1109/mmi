function dirs=dirsgen(filenames)
%generate dir names from filenames

N=size(filenames,1);
dirs=cell(N,1);
for i=1:N
    filename=filenames{i};
    [~,dirname]=name2path(filename);
    dirs{i}=dirname;
end
