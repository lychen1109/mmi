function h=imghist(img,T)
%image histogram

[N,M]=size(img);
img(img>T)=T;
x=0:T;
h=hist(img(:),x);
h=h/(N*M);
