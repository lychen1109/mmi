function D=tpm1d(img,T,trans,normalize)
%tmp horizontal with threshold
%start from pixel value
%if trans==1, transpose the matrix

img=blkproc(img,[8 8],@dct2);
img=round(abs(img));
if trans==1
    img=img';
end

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

if normalize==1
    for i=1:msize
        s=sum(D(i,:));
        if s>0
            D(i,:)=D(i,:)/s;
        end
    end
else
    D=D/N/(M-2);
end




