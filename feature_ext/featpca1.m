function h=featpca1(img,T)
%first pca of 2nd markov feature

img=dcnan(img);
y=img(:,1:127)-img(:,2:end);
y(y>T)=T;
y(y<-T)=-T;
y1=y(:,1:end-2);
y2=y(:,2:end-1);
y3=y(:,3:end);
z=-0.5*y1+0.71*y2-0.5*y3;
B=floor((1+0.71)*T);
X=-B:B;
h=hist(z(:),X);
L=sum(~isnan(z(:)));
h=h/L;