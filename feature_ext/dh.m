function dhist=dh(img,T)
%difference histogram

[N,M]=size(img);
diffimg=img(:,1:M-1)-img(:,2:M);
diffimg(diffimg>T)=T;
diffimg(diffimg<-T)=-T;
diffimg2=0.71*(diffimg(:,1:M-2)-diffimg(:,2:M-1));
clear diffimg;
B=floor(0.71*2*T);
dhist=hist(diffimg2(:),-B:B);
dhist=dhist/(N*(M-2));
