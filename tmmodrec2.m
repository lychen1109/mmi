function [change,diff]=tmmodrec2(img,bdctimg,sj,sk,flag,T)
%calculate mod effect on bdct domain while image is modified on spatial
%domain

img(sj,sk)=img(sj,sk)+flag;
j0=floor((sj-1)/8)*8;
k0=floor((sk-1)/8)*8;
newblock=dct2(img(j0+1:j0+8,k0+1:k0+8));
newblock=abs(round(newblock));
diff=zeros(size(bdctimg));
diff(j0+1:j0+8,k0+1:k0+8)=newblock-bdctimg(j0+1:j0+8,k0+1:k0+8);
bdctchange=find(diff);
change=zeros(2*T+1,2*T+1);
for s=1:length(bdctchange)
    [jdelta,kdelta]=ind2sub(size(bdctimg),bdctchange(s));
    change1=tmmodrec(bdctimg,jdelta,kdelta,diff(jdelta,kdelta),T);
    bdctimg(jdelta,kdelta)=bdctimg(jdelta,kdelta)+diff(jdelta,kdelta);
    change(change1(:,1))=change(change1(:,1))+change1(:,2);
end
change=nzelements(change);
diff=nzelements(diff);

