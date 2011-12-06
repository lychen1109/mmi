function dist=distcalc(img,tmtarget)
%calculate distance between current image and target tpm

T=3;
bdct=blkproc(img,[8 8],@dct2);
bdct=abs(round(bdct));
tm=tpm1(bdct,T);
dist=norm(tm(:)-tmtarget(:));