function shist=sumhistn(img,T)
%sum histogram feature extraction

img=dcnan(img);
[~,M]=size(img);
diffimg=img(:,1:M-1)-img(:,2:M);
diffimg(diffimg>T)=T;
diffimg(diffimg<-T)=-T;
sumimg=0.71*(diffimg(:,1:M-2)+diffimg(:,2:M-1));
clear diffimg;
B=floor(0.71*2*T);
shist=hist(sumimg(:),-B:B);
L=sum(~isnan(sumimg(:)));
shist=shist/L;