function feat=dhgen(imgs,T)
%difference histogram feature generation

N=size(imgs,1);
feat=zeros(N,2*T+1);

for i=1:N
    img=imgs(i,:);
    img=reshape(img,128,128);
    dhist=dh(img,T);
    feat(i,:)=dhist(:)';
end
