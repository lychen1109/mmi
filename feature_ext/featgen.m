function feat=featgen(bdctimgs)
%feature generation for all images

N=size(bdctimgs,1);
feat=zeros(N,168);

for i=1:N
    bdctimg=bdctimgs(i,:);
    bdctimg=reshape(bdctimg,128,128);
    h=featmoment(bdctimg);
    feat(i,:)=h;
    fprintf('%dth image done.\n',i);
end
