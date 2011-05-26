function h=featpca2(img,T)
%2nd pca filter for 2nd degree markov transition

y=img(:,1:end-1)-img(:,2:end);
% y(y>T)=T;
% y(y<-T)=-T;
s=2^-0.5;
y=s*(y(:,1:end-2)-y(:,3:end));
B=T;
h=hist(y(:),-B:B);
h=h/(128*126);