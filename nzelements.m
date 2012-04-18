function nze=nzelements(mat)
%non zero elements of a matrix

nz=find(mat);
nze=zeros(length(nz),2);
nze(:,1)=nz;
nze(:,2)=mat(nz);
