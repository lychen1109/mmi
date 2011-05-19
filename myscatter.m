function myscatter(imgs)
% scatter of joint gradient feature

T=4;
N=size(imgs,1);
idx=ceil(N*rand);
img=imgs(idx,:);
img=reshape(img,128,128);
y=img(:,1:127)-img(:,2:128);
%y(y>T)=T;
%y(y<-T)=-T;
y1=y(:,1:126);
y2=y(:,2:127);
scatter(y1(:),y2(:));
