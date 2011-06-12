function r=pixcorr2(img,T)
%pixel correlation of difference image

Y=img(:,1:end-1)-img(:,2:end);
Y(Y>T)=T;
Y(Y<-T)=-T;
Z1=Y(:,1:end-2);
Z2=Y(:,3:end);
cm=corr([Z1(:) Z2(:)]);
r=cm(1,2);

