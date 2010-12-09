function features=featuregenbdct(path,T,channel,fun)
%generate features from path

files=dir([path filesep '*.tif']);
n_files=length(files);
features=zeros(2*T+1,2*T+1,n_files);
for i=1:n_files
    img=imread([path filesep files(i).name]);
    if isa(img,'uint16')
        img=round(double(img)*255/65535);
    end
    [img_y,img_cb,img_cr]=myrgb2ycbcr(img);
    if channel==1
        img_ch=img_y;
    elseif channel==2
        img_ch=img_cb;
    else
        img_ch=img_cr;
    end    
    bdct_ch=abs(round(blkproc(img_ch,[8 8],@dct2)));
    D=fun(bdct_ch,T);
    features(:,:,i)=D;    
end




