function shist=sumhist(img,T)
%sum histogram feature extraction

[N,M]=size(img);
diffimg=img(:,1:M-1)-img(:,2:M);
diffimg(diffimg>T)=T;
diffimg(diffimg<-T)=-T;
sumimg=diffimg(:,1:M-2)+diffimg(:,2:M-1);
clear diffimg;
X=-2*T:2*T;
shist=hist(sumimg(:),X);
shist=shist/(N*(M-2));