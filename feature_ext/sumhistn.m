function shist=sumhistn(img,T)
%sum histogram feature extraction

img=img-mean(img(:));
img=blkproc(img,[8 8],@dct2);
img=abs(img);
img=dcnan(img);

[~,M]=size(img);
diffimg=img(:,1:M-1)-img(:,2:M);
diffimg(diffimg>T)=T;
diffimg(diffimg<-T)=-T;
sumimg=diffimg(:,1:M-2)+diffimg(:,2:M-1);
clear diffimg;
shist=hist(sumimg(:),-2*T:2*T);
L=sum(~isnan(sumimg(:)));
shist=shist/L;