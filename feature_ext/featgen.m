function feat=featgen(imgs)
%feature generation for all images

N=size(imgs,1);
feat=zeros(N,46);

for i=1:N
    img=imgs(i,:);
    img=reshape(img,128,128);
    h1=dhn(img,8);
    h2=sumhistn(img,8);    
    feat(i,:)=[h1(:)' h2(:)'];
end
