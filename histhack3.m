function [bdctimg,dist_ori,dist]=histhack3(img,timg)
%change only on bdct domain

bdcttarget=blkproc(timg,[8 8],@dct2);
bdcttarget=abs(round(bdcttarget));
T=3;
tmtarget=tpm1(bdcttarget,T);

bdctimg=blkproc(img,[8 8],@dct2);
bdctimg=abs(round(bdctimg));
tm=tpm1(bdctimg,T);

dist_ori=norm(tm(:)-tmtarget(:));
modified=false(size(img));
dist=dist_ori;
iter=1;

while iter<5000 && dist>1e-3
    randidx=randperm(128^2-256);
    idx=1;
    [sj,sk]=ind2sub(size(img),randidx(idx));
    [flag,mindist]=flagcreationl2(bdctimg,tmtarget,sj,sk);
    while isequal(flag,[0 0 0]) || any(modified(sj,sk:sk+2)&(flag~=0))
        idx=idx+1;
        [sj,sk]=ind2sub(size(img),randidx(idx));
        [flag,mindist]=flagcreationl2(bdctimg,tmtarget,sj,sk);
    end
    if ~(isequal(flag,[0 0 0]) || any(modified(sj,sk:sk+2)&(flag~=0)))
        bdctimg(sj,sk:sk+2)=bdctimg(sj,sk:sk+2)+flag;
        modified(sj,sk:sk+2)=modified(sj,sk:sk+2)|(flag~=0);
        dist=mindist;
        fprintf('iter %d: %g\n',iter,dist);
        iter=iter+1;
    else
        break
    end
end


