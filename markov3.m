function h=markov3(img,T)
%2nd pca filter for 2nd degree markov transition

y=img(:,1:end-1)-img(:,2:end);
y(y>T)=T;
y(y<-T)=-T;
y=y(:,1:end-2)-y(:,3:end);
h=hist(y(:),-2*T:2*T);
h=h/(128*126);