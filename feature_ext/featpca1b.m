function h=featpca1b(img)
%pca1 feature without threshold

y=img(:,1:127)-img(:,2:end);
y1=y(:,1:end-2);
y2=y(:,2:end-1);
y3=y(:,3:end);
s=2^-0.5;
z=-0.5*y1+s*y2-0.5*y3;
B=8;
h=hist(z(:),-B:B);
h=h/length(z(:));