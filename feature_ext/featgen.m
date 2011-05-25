function feat=featgen(imgs,T,D)
%feature generation for all images

N=size(imgs,1);
feat=zeros(N,D);

for i=1:N
    img=imgs(i,:);
    img=reshape(img,128,128);
    dhist=featpca2(img,T);
    feat(i,:)=dhist(:)';
end
