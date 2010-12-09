function [features,features_cr]=featuregeni(path,T,fun)
%pixel space feature generation

files=dir([path filesep '*.tif']);
n_files=length(files);
features=zeros(2*T+1,2*T+1,n_files);
features_cr=zeros(2*T+1,2*T+1,n_files);
for i=1:n_files
    img=imread([path filesep files(i).name]);
    if isa(img,'uint16')
        img=round(double(img)*255/65535);
    else
        img=double(img);
    end
    img_y=0.3*img(:,:,1)+0.59*img(:,:,2)+0.11*img(:,:,3);
    img_y=round(img_y);
    D=fun(img_y,T);
    features(:,:,i)=D;
    
    img_cr=128+0.5*img(:,:,1)-0.419*img(:,:,2)-0.0813*img(:,:,3);
    img_cr=round(img_cr);
    D_cr=fun(img_cr,T);
    features_cr(:,:,i)=D_cr;
end
