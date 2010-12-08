function features=featuregeni(path,T,fun)
%pixel space feature generation

files=dir([path filesep '*.tif']);
n_files=length(files);
features=zeros(2*T+1,2*T+1,n_files);
for i=1:n_files
    img=imread([path filesep files(i).name]);
    if isa(img,'uint16')
        img=round(double(img)*255/65535);
    else
        img=double(img);
    end
    img=0.3*img(:,:,1)+0.59*img(:,:,2)+0.11*img(:,:,3);
    img=round(img);
    D=fun(img,T);
    features(:,:,i)=D;
end
