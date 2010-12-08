function features=featuregen(path,T,fun)
%generate features from path

files=dir([path filesep '*.tif']);
n_files=length(files);
features=zeros(2*T+1,2*T+1,n_files);
for i=1:n_files
    img=imread([path filesep files(i).name]);
    if isa(img,'uint16')
        img=uint8(round(double(img)*255/65535));
    end    
    t='temp.jpg';
    imwrite(img,t,'jpg','Quality',100);
    clear img;
    jobj=jpeg_read(t);
    delete(t);
    img=abs(jobj.coef_arrays{1});
    D=fun(img,T);
    features(:,:,i)=D;
end




