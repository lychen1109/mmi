function imageinvest(path)
%invest image info in a directory

files=dir([path filesep '*.tif']);
n_files=length(files);

for i=1:n_files
    info=imfinfo([path filesep files(i).name]);
    fprintf('%s\t%d\t%s\n',files(i).name,info.BitDepth,info.ColorType);
end
