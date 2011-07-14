function feat=featgen(bdctimgs,edges)
%feature generation for all images

N=size(bdctimgs,1);
feat=zeros(N,11^2);

for i=1:N
    bdctimg=bdctimgs(i,:);
    bdctimg=reshape(bdctimg,128,128);
    cmat=cooccount(bdctimg,edges);
    feat(i,:)=cmat(:)';
end
