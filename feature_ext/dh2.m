function dhist=dh2(img,T)
%unthreshold version of difference histogram

x1=img(:,1:end-2);
x2=img(:,2:end-1);
x3=img(:,3:end);
z=0.71*(x1-2*x2+x3);
X=-T:T;
dhist=hist(z(:),X);
dhist=dhist/(length(z(:)));