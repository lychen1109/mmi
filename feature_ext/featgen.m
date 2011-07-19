function feat=featgen(bdctimgs)
%feature generation for all images

N=size(bdctimgs,1);
feat=zeros(N,91);

for i=1:N
    bdctimg=bdctimgs(i,:);
    bdctimg=reshape(bdctimg,128,128);
    h=hffeat(bdctimg);
    feat(i,:)=h;
end
