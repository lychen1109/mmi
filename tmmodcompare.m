function tmmodcompare(img)
%compare performance of tmmod approach

img=reshape(img,128,128);
tms=tpm1(img,3);
bdctimg=blkproc(img,[8 8],@dct2);
bdctimg=abs(round(bdctimg));
tm=tpm1(bdctimg,3);

sj=100;
sk=101;
img1=img;
img1(sj,sk)=img1(sj,sk)+1;
%normal tpm generation method
tic;
newtms1=tpm1(img1,3);
bdctimg1=blkproc(img1,[8 8],@dct2);
bdctimg1=abs(round(bdctimg1));
newtm1=tpm1(bdctimg1,3);
toc;

%use faster algorithm
tic;
out=tmmod2(img,tms,sj,sk,1,3);
newtms2=out.tm;
j0=floor((sj-1)/8)*8;
k0=floor((sk-1)/8)*8;
        
newblock=dct2(img1(j0+1:j0+8,k0+1:k0+8));
newblock=abs(round(newblock));
diff=newblock-bdctimg(j0+1:j0+8,k0+1:k0+8);
changed=find(diff);

%calculate newtm
newtm2=tm;
newbdctimg=bdctimg;
for s=1:length(changed)
    [jdelta,kdelta]=ind2sub([8 8],changed(s));
    outbdct=tmmod2(newbdctimg,newtm2,j0+jdelta,k0+kdelta,diff(jdelta,kdelta),3);
    newbdctimg(j0+jdelta,k0+kdelta)=newblock(jdelta,kdelta);
    newtm2=outbdct.tm;
end
toc;

%use tmmod3
tic;
[tms3,tm3]=tmmod3(img,bdctimg,tms,tm,sj,sk,1,3);
toc;

isequal(newtms1,newtms2)
isequal(newtm1,newtm2)
isequal(newtms1,tms3)
isequal(newtm1,tm3)



