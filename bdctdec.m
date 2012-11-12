function img=bdctdec(bdctimg)
%decode image from bdct coef

bdctimg=reshape(bdctimg,128,128);
img=blkproc(bdctimg,[8 8],@idct2);
img=round(img);
img(img>255)=255;
img(img<0)=0;
