function feat=imhistgen(images,n)
%imhist feat gen

images=uint8(images);
N=size(images,1);
feat=zeros(N,n);
R=128^2;
for i=1:N
    img=images(i,:);
    img=reshape(img,128,128);
    counts=imhist(img,n);
    feat(i,:)=counts(:)'/R;
end
