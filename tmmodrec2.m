function change=tmmodrec2(img,bdctimg,sj,sk,flag,T)
%calculate mod effect on bdct domain while image is modified on spatial
%domain

img(sj,sk)=img(sj,sk)+flag;
j0=floor((sj-1)/8)*8;
k0=floor((sk-1)/8)*8;
newblock=dct2(img(j0+1:j0+8,k0+1:k0+8));
newblock=abs(round(newblock));
diff=newblock-bdctimg(j0+1:j0+8,k0+1:k0+8);
bdctchange=find(diff);
change=zeros(2*T+1,2*T+1);
for s=1:length(bdctchange)
    [jdelta,kdelta]=ind2sub([8 8],bdctchange(s));
    change1=tmmodrec(bdctimg,j0+jdelta,k0+kdelta,diff(jdelta,kdelta),T);
    %newbdctimg(j0+jdelta,k0+kdelta)=newblock(jdelta,kdelta);
    change(change1(:,1))=change(change1(:,1))+change1(:,2);
end
change=nzelements(change);


