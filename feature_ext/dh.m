function dhist=dh(img,T)
%difference histogram

[N,M]=size(img);
diffimg=img(:,1:M-1)-img(:,2:M);
diffimg(diffimg>T)=T;
diffimg(diffimg<-T)=-T;
diffimg2=diffimg(:,1:M-2)-diffimg(:,2:M-1);
clear diffimg;
X=-2*T:2*T;
dhist=hist(diffimg2(:),X);
dhist=dhist/(N*(M-2));
