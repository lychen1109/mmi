function features=featuregeni(path,T,channel,fun)
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
    [img_y,img_cb,img_cr]=myrgb2ycbcr(img);
    if channel==1
        img_ch=img_y;
    elseif channel==2
        img_ch=img_cb;
    else
        img_ch=img_cr;
    end
    D=fun(img_ch,T);
    features(:,:,i)=D;    
end
