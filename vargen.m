function Z=vargen(img)
%adjacent variable generation from bdctimg

img=img-mean(img(:));
img=blkproc(img,[8 8],@dct2);
img=abs(round(img));
Y=img(:,1:end-1)-img(:,2:end);
%Y(Y>T)=T;
%Y(Y<-T)=-T;
Z1=Y(:,1:end-1);
Z2=Y(:,2:end);
Z=[Z2(:) Z1(:)];

