function [ distmat ] = crossdist( A,B,gt )
%distance calculation of pair instances in vector A and B
%   when A==B, the function use symetric of matrix to save half of the
%   computing time

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

%prepare sample index
idxA=repmat((1:NA)',1,NB);
idxB=repmat(1:NB,NA,1);

if ~ isequal(A,B)
    parfor i=1:NA*NB
        distmat(i)=sampledist(idxA(i),idxB(i),A,B);
    end    
else
    lidx=tril(true(NA),-1);
    lidxA=idxA(lidx);
    lidxB=idxB(lidx);    
    n_subidx=(NA^2-NA)/2;
    ldistmat=distmat(lidx);
    parfor i=1:n_subidx
        ldistmat(i)=sampledist(lidxA(i),lidxB(i),A,B);
    end
    distmat(lidx)=ldistmat;    
    distmat=distmat+distmat';
end
end

    
function dist=sampledist(iA,iB,A,B)
%calculate distance between two sample pairs

s1=A(iA,:);
s2=B(iB,:);
dist=norm(s1-s2)^2;
end


