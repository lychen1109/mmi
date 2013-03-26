function [bdctimg]=histhack_sel(img,imgtarget,K,T,selection)
%change only on bdct domain
%K: dymamic range of coefficients
%T: threshold of co-occurrence matrix
%Only change coeff in selection

tpmopt=1;
%reshape images
M=length(img(:));
M=sqrt(M);
img=reshape(img,M,M);
imgtarget=reshape(imgtarget,M,M);

%create target matrix
bdcttarget=blkproc(imgtarget,[8 8],@dct2);
bdcttarget=abs(round(bdcttarget));
tmtarget=tpm1(bdcttarget,T,tpmopt);

bdctimg=blkproc(img,[8 8],@dct2);
bdctimg=round(bdctimg);
bdctsign=sign(bdctimg);
bdctimg=abs(bdctimg);
tm=tpm1(bdctimg,T,tpmopt);
fprintf('initial distance of samples: %g\n',norm(tm(:)-tmtarget(:)));

[SJ,SK]=find(selection);
pointsize=length(SJ);
sorted=randperm(pointsize);

for i=1:pointsize
    nodeidx=sorted(i);
    output=flaggen(bdctimg,tmtarget,SJ(nodeidx),SK(nodeidx),tm,T,K);
    if ~output.modified
        continue;
    end
    bdctimg(SJ(nodeidx),SK(nodeidx))=bdctimg(SJ(nodeidx),SK(nodeidx))+output.flag;
    tm=output.tm;
end
tm=tpm1(bdctimg,T,tpmopt);
fprintf('Final distance of samples: %g\n',norm(tm(:)-tmtarget(:)));
bdctimg=bdctimg.*bdctsign;

function output=flaggen(bdctimg,tmtarget,sj,sk,tm,T,K)
%calculate the best flag for current pixel
%dist_ori=norm(tm(:)-tmtarget(:));
dist_ori=sampledist(tm(:),tmtarget(:));
output.dist=dist_ori;
output.modified=false;
for i=max(-K,-bdctimg(sj,sk)):K
    if i==0
        continue;
    end
    out=tmmod2(bdctimg,tm,sj,sk,i,T);
    if ~out.changed
        continue;
    end
    tmnew=out.tm;
    %dist=norm(tmnew(:)-tmtarget(:));
    dist=sampledist(tmnew(:),tmtarget(:));
    if dist<dist_ori
        output.modified=true;
        dist_ori=dist;
        output.tm=out.tm;
        output.flag=i;
        output.dist=dist;
    end
end

function dist=sampledist(tm1,tm2)
%return normalized distance
%tm1=tm1(:)';
%tm2=tm2(:)';
%tm1=svmrescale(tm1,range);
%tm2=svmrescale(tm2,range);
%dist=sum(abs(tm1-tm2).*w(:));
dist=norm(tm1-tm2);









