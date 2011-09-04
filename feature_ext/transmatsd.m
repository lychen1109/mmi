function tm=transmatsd(images)
%transmat of scale-down version of images

N=size(images,1);
T=4;
tm=zeros(2*T+1,2*T+1,N);
for i=1:N
    img=images(i,:);
    img=reshape(img,128,128);
    img=imresize(img,0.5,'method','bilinear','antialiasing',false);
    bdctmat=blkproc(img,[8 8],@dct2);
    bdctmat=abs(round(bdctmat));
    D=tpm1(bdctmat,T);
    tm(:,:,i)=D;
end
