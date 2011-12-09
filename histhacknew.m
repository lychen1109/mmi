function [img,distrec]=histhacknew(img,timg)
%modify image in pixel domain, with L2 distance as standard

%calculate target tpm
T=3;
bdcttarget=blkproc(timg,[8 8],@dct2);
bdcttarget=abs(round(bdcttarget));
tmtarget=tpm1(bdcttarget,T);

bdctimg=blkproc(img,[8 8],@dct2);
bdctimg=round(bdctimg);
bdctsign=sign(bdctimg);
bdctsign(bdctsign==0)=1;
bdctimg=abs(bdctimg);
tm=tpm1(bdctimg,T);

dist_current=norm(tm(:)-tmtarget(:));
distrec=dist_current;%record dist in every iteration
iter=0;
fprintf('iter %d: %g\n',iter,distrec(end));

while iter<1000 && dist_current>1e-4
    coefloc=randperm(128^2-256);
    coefidx=1;
    [flag,moddist,mindist]=flagcreationl2(bdctimg,tmtarget,coefloc(coefidx));
    while moddist>=0 && coefidx<=128^2-256
        coefidx=coefidx+1;
        [flag,moddist,mindist]=flagcreationl2(bdctimg,tmtarget,coefloc(coefidx));
    end
    if moddist>=0
        break;
    end
    dist_current=mindist;
    [sj,sk]=ind2sub(size(bdctimg),coefloc(coefidx));
    bdctimg(sj,sk:sk+2)=bdctimg(sj,sk:sk+2)+flag;
    iter=iter+1;     
    distrec=cat(1,distrec,dist_current);    
    fprintf('iter %d: %g\n',iter,dist_current);
    if mod(iter,20)==0
        img=bdctdec(bdctimg.*bdctsign);
        bdctimg=blkproc(img,[8 8],@dct2);
        bdctimg=round(bdctimg);
        bdctsign=sign(bdctimg);
        bdctsign(bdctsign==0)=1;
        bdctimg=abs(bdctimg);
    end        
end
