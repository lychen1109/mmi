function [tmat,sumimg,diffimg2]=transtpm(img,T)
%transformed transition probability matrix of bdct difference array

img=img-mean(img(:));
bdct=blkproc(img,[8 8],@dct2);
bdct=round(abs(bdct));
diffimg=bdct(:,1:end-1)-bdct(:,2:end);
sumimg=diffimg(:,1:end-1)+diffimg(:,2:end);
diffimg2=diffimg(:,1:end-1)-diffimg(:,2:end);
sumimg(sumimg>T)=T;
sumimg(sumimg<-T)=-T;
diffimg2(diffimg2>T)=T;
diffimg2(diffimg2<-T)=-T;
sumimg=sumimg+T+1;
diffimg2=diffimg2+T+1;
tmat=zeros(2*T+1,2*T+1);

[N,M]=size(img);
for i=1:N
    for j=1:M-2
        tmat(sumimg(i,j),diffimg2(i,j))=tmat(sumimg(i,j),diffimg2(i,j))+1;
    end
end
tmat=tmat/N/(M-2);




