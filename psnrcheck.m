function psnrvalues=psnrcheck(bdctimgs,images)
%check psnr values

N=size(images,1);
psnrvalues=zeros(N,1);
for i=1:N
    bdctimg=bdctimgs(i,:);
    bdctimg=reshape(bdctimg,128,128);
    img2=bdctdec(bdctimg);
    img=images(i,:);
    img=reshape(img,128,128);
    psnrvalues(i)=psnr(img,img2);
end
