function Z=vargen2(imgs,T)
%adjacent variable generation from bdctimg

N=size(imgs,1);
imgs=reshape(imgs',128,128,N);
Y=imgs(:,1:end-1,:)-imgs(:,2:end,:);
Y(Y>T)=T;
Y(Y<-T)=-T;
Z1=Y(:,1:end-1,:);
Z2=Y(:,2:end,:);
Z=[Z1(:) Z2(:)];

