function D=tpm1(img,T)
%tmp horizontal with threshold

[N,M]=size(img);
img=blkproc(img,[8 8],@dct2);
img=abs(round(img));
diffimg=img(1:N-1,1:M-1)-img(1:N-1,2:M);
%diffimg=round(diffimg);

diffimg(diffimg>T)=T;
diffimg(diffimg<-T)=-T;
diffimg=diffimg+T+1;
msize=2*T+1;

D=zeros(msize,msize);
for i=1:N-1
    for j=1:M-2
       D(diffimg(i,j),diffimg(i,j+1))=D(diffimg(i,j),diffimg(i,j+1))+1;
    end
end
D=D/((N-1)*(M-2));




