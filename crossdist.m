function [ distmat ] = crossdist( A,B,gt )
%crossdist calculate cross distance between samples in A and B
%   Detailed explanation goes here

NA=size(A,1);
NB=size(B,1);
distmat=zeros(NA,NB);

if nargin==3
    %make sure gt is row vector
    if size(gt,2)==1
        gt=gt';
    end
    
    %rescale A and B according to gt
    A=repmat(gt,NA,1).*A;
    B=repmat(gt,NB,1).*B;
end

if ~ isequal(A,B)
    for i=1:NA
        for j=1:NB
            distmat(i,j)=norm(A(i,:)-B(j,:));
        end
    end
    distmat=distmat.^2;
else
    if NA>1
        for i=1:NA-1
            for j=i+1:NA
                distmat(i,j)=norm(A(i,:)-B(j,:));
            end
        end
        distmat=(distmat+distmat').^2;
    else
        distmat=0;
    end
end


end

