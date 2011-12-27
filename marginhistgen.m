function feat=marginhistgen(images,T)
%batch processing of images

N=size(images,1);
feat=zeros(N,2*T+1);
for i=1:N
    img=images(i,:);
    img=reshape(img,128,128);
    feat(i,:)=marginhist(img,T);
end
