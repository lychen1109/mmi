function h=featpca3(img,T)
%pca 3rd component of 2nd order markov feature

y=img(:,1:end-1)-img(:,2:end);
y1=y(:,1:end-2);
y2=y(:,2:end-1);
y3=y(:,3:end);
z=0.5*y1+0.71*y2+0.5*y3;
h=hist(z(:),-T:T);
h=h/length(z(:));