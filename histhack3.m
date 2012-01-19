function [bdctimg,delta,dist_ori,dist]=histhack3(img,timg)
%change only on bdct domain

bdcttarget=blkproc(timg,[8 8],@dct2);
bdcttarget=abs(round(bdcttarget));
T=3;
tmtarget=tpm1(bdcttarget,T);
tmtarget=rownorm(tmtarget);

bdctimg=blkproc(img,[8 8],@dct2);
bdctimg=round(bdctimg);
bdctimgori=bdctimg;
bdctsign=sign(bdctimg);
bdctsign(bdctsign==0)=1;
bdctimg=abs(bdctimg);
tm=tpm1(bdctimg,T);
tmnorm=rownorm(tm);

dist_ori=norm(tmnorm(:)-tmtarget(:));
dist=dist_ori;
randidx=randperm(127*128);
for i=1:127*128
    [sj,sk]=ind2sub([127 128],randidx(i));
    output=flaggen(bdctimg,tmtarget,sj,sk,tm);
    if output.modified
        bdctimg(sj,sk)=bdctimg(sj,sk)+output.flag;
        tm=output.tm;
        dist=output.dist;
    end
    if mod(i,1000)==0
        fprintf('i %d: %g\n',i,dist);
    end
end

fprintf('final dist: %g\n',dist);
bdctimg=bdctimg.*bdctsign;
delta=bdctimgori-bdctimg;

function output=flaggen(bdctimg,tmtarget,sj,sk,tm)
%calculate the best flag for current pixel
tmnorm=rownorm(tm);
dist_ori=norm(tmnorm(:)-tmtarget(:));
output.modified=false;
for i=max(-1,-bdctimg(sj,sk)):1
    if i==0
        continue;
    end
    out=tmmod2(bdctimg,tm,sj,sk,i,3);
    if ~out.changed
        continue;
    end
    tmnorm=rownorm(out.tm);
    dist=norm(tmnorm(:)-tmtarget(:));
    if dist<dist_ori
        output.modified=true;
        dist_ori=dist;
        output.tm=out.tm;
        output.flag=i;
        output.dist=dist;
    end
end





