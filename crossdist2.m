function [ distmat ] = crossdist2( A,B,gt )
%crossdist2 use two loop to fill distmat
%   Detailed explanation goes here

%make sure gt is row vector
if size(gt,2)==1
    gt=gt';
end

NA=size(A,1);
NB=size(B,1);
distmat=zeros(NA,NB);

%rescale A and B according to gt
A=repmat(gt,NA,1).*A;
B=repmat(gt,NB,1).*B;

if ~ isequal(A,B)
    for i=1:NA
        for j=1:NB
            distmat(i,j)=norm(A(i,:)-B(j,:));
        end
    end
    distmat=distmat.^2;
else
    for i=1:NA-1
        for j=i+1:NA
            distmat(i,j)=norm(A(i,:)-B(j,:));
        end
    end
    distmat=(distmat+distmat').^2;
end


end

