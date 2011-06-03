function h=featpca3(img,T)
%pca 3rd component of 2nd order markov feature

img=dcnan(img);
y=img(:,1:end-1)-img(:,2:end);
%y(y>T)=T;
%y(y<-T)=-T;
y1=y(:,1:end-2);
y2=y(:,2:end-1);
y3=y(:,3:end);
z=0.5*y1+0.71*y2+0.5*y3;
B=floor(1.71*T);
h=hist(z(:),-B:B);
L=sum(~isnan(z(:)));
h=h/L;