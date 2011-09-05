function filtereva(n,images,h)
%filter evaluation
%n is the number of image to evaluate

img=images(n,:);
img=reshape(img,128,128);
filteredimg=imfilter(img,h);

bdct=blkproc(img,[8 8],@dct2);
bdct=abs(round(bdct));
tmbf=tpm1(bdct,4);

bdct=blkproc(filteredimg,[8 8],@dct2);
bdct=abs(round(bdct));
tmaf=tpm1(bdct,4);

subplot(2,2,1);
imagesc(img),colormap gray

subplot(2,2,2);
imagesc(filteredimg),colormap gray

mb=max(tmbf(:));
ma=max(tmaf(:));
m=max(mb,ma);
m=ceil(m*10)/10;

subplot(2,2,3);
mesh(tmbf);
axis([0 10 0 10 0 m]);

subplot(2,2,4);
mesh(tmaf);
axis([0 10 0 10 0 m]);
