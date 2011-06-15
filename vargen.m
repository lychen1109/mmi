function Z=vargen(img,T)
%adjacent variable generation from bdctimg

Y=img(:,1:end-1)-img(:,2:end);
Y(Y>T)=T;
Y(Y<-T)=-T;
Z1=Y(:,1:end-1);
Z2=Y(:,2:end);
Z=[Z1(:) Z2(:)];

