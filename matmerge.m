function mat=matmerge(mat1,mat2)
%merge two matrix in 3rd dimension

l1=size(mat1,3);
l2=size(mat2,3);
mat=zeros(size(mat1,1),size(mat1,2),l1+l2);
mat(:,:,1:l1)=mat1;
mat(:,:,l1+1:end)=mat2;