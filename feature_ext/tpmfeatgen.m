function feat=tpmfeatgen(imgs,T)
%feature generation for transition probabilty matrix

N=size(imgs,1);
fd=((2*T+1)^2)*2;
feat=zeros(N,fd);

for i=1:N
    img=imgs(i,:);
    img=reshape(img,128,128);
    D=tpm1d(img,T,0,1);
    D1=tpm1d(img,T,1,1);
    feat(i,:)=[D(:)' D1(:)'];
    fprintf('%dth image done.\n',i);
end
