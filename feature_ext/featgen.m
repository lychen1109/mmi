function feat=featgen(imgs)
%feature generation for all images

N=size(imgs,1);
feat=zeros(N,77);

for i=1:N
    img=imgs(i,:);
    img=reshape(img,128,128);
    h1=featpca1(img,8);
    h2=featpca2(img,8);
    h3=featpca3(img,8);
    feat(i,:)=[h1(:)' h2(:)' h3(:)'];
end
