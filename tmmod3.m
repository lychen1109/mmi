function [tms2,tm2]=tmmod3(img,bdctimg,tms,tm,sj,sk,flag,T)
%calculate new tm and tms according to single pixel change

out=tmmod2(img,tms,sj,sk,flag,T);
tms2=out.tm;

img1=img;
img1(sj,sk)=img1(sj,sk)+flag;
j0=floor((sj-1)/8)*8;
k0=floor((sk-1)/8)*8;
newblock=dct2(img1(j0+1:j0+8,k0+1:k0+8));
newblock=abs(round(newblock));
diff=newblock-bdctimg(j0+1:j0+8,k0+1:k0+8);
changed=find(diff);

%calculate newtm
tm2=tm;
newbdctimg=bdctimg;
for s=1:length(changed)
    [jdelta,kdelta]=ind2sub([8 8],changed(s));
    outbdct=tmmod2(newbdctimg,tm2,j0+jdelta,k0+kdelta,diff(jdelta,kdelta),T);
    newbdctimg(j0+jdelta,k0+kdelta)=newblock(jdelta,kdelta);
    tm2=outbdct.tm;
end