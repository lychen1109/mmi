function dhist=dh2(img,T)
%difference histogram of jpg_imgs

[N,M]=size(img);
diffimg=img(:,1:M-1)-img(:,2:M);
diffimg(diffimg>T)=T;
diffimg(diffimg<-T)=-T;
X=-T:T;
dhist=hist(diffimg(:),X);
dhist=dhist/(N*(M-1));