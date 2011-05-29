function cm=pixcorr(imgs,T)
%pixel correlation of difference image

N=size(imgs,1);
imgs=reshape(imgs',128,128,N);
Y=imgs(:,1:end-1,:)-imgs(:,2:end,:);
Y(Y>T)=T;
Y(Y<-T)=-T;
Z1=Y(:,1:end-2,:);
Z2=Y(:,2:end-1,:);
Z3=Y(:,3:end,:);
cm=corr([Z1(:) Z2(:) Z3(:)]);
