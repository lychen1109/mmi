function feat=momentgen(images)
%generate moment features from images

N=size(images,1);
feat=zeros(N,168);
parfor i=1:N
    img=images(i,:);
    img=reshape(img,128,128);
    feat(i,:)=featmoment(img);
end
