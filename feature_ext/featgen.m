function feat=featgen(imgs)
%feature generation for all images

N=size(imgs,1);
feat=zeros(N,33+33);

for i=1:N
    img=imgs(i,:);
    img=reshape(img,128,128);
    h1=dh2(img,16);
    h2=sumhist2(img,16);
    feat(i,:)=[h1(:)' h2(:)'];
end
