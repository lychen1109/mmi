function D=tpmf(diffimg,T)
%seperate pixel count function out of tpm1

[N,M]=size(diffimg);
diffimg(diffimg>T)=T;
diffimg(diffimg<-T)=-T;
diffimg=diffimg+T+1;
msize=2*T+1;

D=zeros(msize,msize);
for i=1:N
    for j=1:M-1
       D(diffimg(i,j),diffimg(i,j+1))=D(diffimg(i,j),diffimg(i,j+1))+1;
    end
end
D=D/(N*(M-1));