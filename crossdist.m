function [ distmat ] = crossdist( A,B,gt )
%distance calculation of pair instances in vector A and B
%   when A==B, the function use symetric of matrix to save half of the
%   computing time

NA=size(A,1);
NB=size(B,1);
distmat=zeros(NA*NB,1);
idx=zeros(NA*NB,size(A,2),2);
for i=1:NA
    idx((i-1)*NB+(1:NB),:,1)=A(i,:);
    idx((i-1)*NB+(1:NB),:,2)=B;
end

if ~ isequal(A,B)
    parfor i=1:NA*NB
        distmat(i)=sampledist(idx(i,:,:),gt);
    end
    distmat=reshape(distmat,NB,NA)';
else
    lidx=tril(true(NA),-1);
    for i=find(lidx)
        distmat(i)=sampledist(idx(i,:,:),gt);
    end
    distmat=reshape(distmat,NB,NA)';
    distmat=distmat+distmat';
end

function dist=sampledist(samples,gt)
%calculate distance between two sample pairs
s1=samples(1,:,1);
s2=samples(1,:,2);
dist=norm(s1.*gt,s2.*gt)^2;


