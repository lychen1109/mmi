function D=tpm1(img,T)
%tmp horizontal with threshold

[N,M]=size(img);
diffimg=img(:,1:M-1)-img(:,2:M);

diffimg(diffimg>T)=T;
diffimg(diffimg<-T)=-T;
diffimg=diffimg+T+1;
msize=2*T+1;

D=zeros(msize,msize);
for i=1:N
    for j=1:M-2
       D(diffimg(i,j),diffimg(i,j+1))=D(diffimg(i,j),diffimg(i,j+1))+1;
    end
end
D=D/(N*(M-2));




