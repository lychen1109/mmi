function dhist=dhn(img,T)
%difference histogram, mark the dc component as nan

img=dcnan(img);
[~,M]=size(img);
diffimg=img(:,1:M-1)-img(:,2:M);
%diffimg(diffimg>T)=T;
%diffimg(diffimg<-T)=-T;
diffimg2=0.71*(diffimg(:,1:M-2)-diffimg(:,2:M-1));
clear diffimg;
B=floor(0.71*2*T);
dhist=hist(diffimg2(:),-B:B);
L=sum(~isnan(diffimg2(:)));
dhist=dhist/(L);
