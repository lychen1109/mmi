function feat=sdfeatgen(imgs,T)
%feature generation for transition probabilty matrix

N=size(imgs,1);
fd=(4*T+1)*4;
feat=zeros(N,fd);

for i=1:N
    img=imgs(i,:);
    img=reshape(img,128,128);
    h1=sdhist(img,T,0);
    h2=sdhist(img,T,1);
    feat(i,:)=[h1(:)' h2(:)'];
    fprintf('%dth image done.\n',i);
end
