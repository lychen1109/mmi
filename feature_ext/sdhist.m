function h=sdhist(img,T,trans)
%sum and difference histogram feature extraction

img=img-mean(img(:));
img=blkproc(img,[8 8],@dct2);
img=abs(img);
img=dcnan(img);
if trans==1
    img=img';
end

[~,M]=size(img);
diffimg=img(:,1:M-1)-img(:,2:M);
diffimg(diffimg>T)=T;
diffimg(diffimg<-T)=-T;
simg=diffimg(:,1:M-2)+diffimg(:,2:M-1);
dimg=diffimg(:,1:M-2)-diffimg(:,2:M-1);

shist=hist(simg(:),-2*T:2*T);
dhist=hist(dimg(:),-2*T:2*T);
L=sum(~isnan(simg(:)));
shist=shist/L;
dhist=dhist/L;
h=[shist dhist];