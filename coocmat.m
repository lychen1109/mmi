function cmat=coocmat(img)
%horizontal coocurrent matrix

[N,M]=size(img);
diffimg=img(:,1:M-1)-img(:,2:M);
diffimg=diffimg+256;
cmat=zeros(511,511);
for i=1:N
    for j=1:M-2
        cmat(diffimg(i,j),diffimg(i,j+1))=cmat(diffimg(i,j),diffimg(i,j+1))+1;
    end
end

