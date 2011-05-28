function h=featpca2(img,T)
%2nd pca filter for 2nd degree markov transition

y=img(:,1:end-1)-img(:,2:end);
y(y>T)=T;
y(y<-T)=-T;
y=0.71*(y(:,1:end-2)-y(:,3:end));
B=floor(0.71*2*T);
h=hist(y(:),-B:B);
h=h/(length(y(:)));