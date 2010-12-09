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
    [img_y,~,img_cr]=myrgb2ycbcr(img);    
    D=fun(img_y,T);
    features(:,:,i)=D;    
        
    D_cr=fun(img_cr,T);
    features_cr(:,:,i)=D_cr;
end
