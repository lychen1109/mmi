function [dist,dist1,dist2]=distcalc(img,targetimg)
%calculate distance between current image and target img

T=3;
img=reshape(img,128,128);
targetimg=reshape(targetimg,128,128);

bdct=blkproc(img,[8 8],@dct2);
bdct=abs(round(bdct));
tm=tpm1(bdct,T);
N=sum(sum(tm));
tm=tm/N;
tms=tpm1(img,T)/N;

bdcttarget=blkproc(targetimg,[8 8],@dct2);
bdcttarget=abs(round(bdcttarget));
tmtarget=tpm1(bdcttarget,T)/N;
tmstarget=tpm1(targetimg,T)/N;

feat=[tm(:);tms(:)];
feattarget=[tmtarget(:);tmstarget(:)];
dist1=norm(tm(:)-tmtarget(:));
dist2=norm(tms(:)-tmstarget(:));
dist=norm(feat-feattarget);