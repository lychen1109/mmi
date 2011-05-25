function h=featpca1(img,T)
%first pca of 2nd markov feature

y=img(:,1:127)-img(:,2:end);
y(y>T)=T;
y(y<-T)=-T;
y1=y(:,1:end-2);
y2=y(:,2:end-1);
y3=y(:,3:end);
z=-y1+sqrt(2)*y2-y3;
B=ceil((2+sqrt(2))*T);
X=-B:B;
h=hist(z(:),X);
h=h/length(z(:));