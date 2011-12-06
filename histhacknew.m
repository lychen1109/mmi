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
N=1000;
nbatch=10;%number of bdct coeff used in one iteration
tm=tpm1(bdctimg,T);
dist_ori=norm(tm(:)-tmtarget(:));
distrec=dist_ori;%record dist in every iteration
iter=0;
fprintf('iter %d: %g\n',iter,distrec(end));
notfinish=true;

while notfinish      
    flagstruct=flagcreationl2(img,tmtarget,N);
    coefidx=flagstruct.coefidx;
    flags=flagstruct.flags;
    moddist=flagstruct.moddist;
    coefidx=coefidx(moddist<0);
    flags=flags(moddist<0);
    moddist=moddist(moddist<0);
    M=size(flags,1);
    
    [~,sortedidx]=sort(moddist,1,'ascend');
    bdctmod=zeros(size(img));
    dist_current=distrec(end);
    modidx=1;
    while dist_current>=distrec(end) && modidx+nbatch-1<=M
        for i=modidx:modidx+nbatch-1
            [sj,sk]=ind2sub(size(img),coefidx(sortedidx(i)));
            bdctmod(sj,sk:sk+2)=bdctmod(sj,sk:sk+2)+flags(sortedidx(i),:).*bdctsign(sj,sk:sk+2);
        end
        imgmod=blkproc(bdctmod,[8 8],@idct2);
        imgmod=round(imgmod);
        dist_current=distcalc(img+imgmod,tmtarget);
        modidx=modidx+nbatch;
    end    
    
    if dist_current<distrec(end)        
        distrec=cat(1,distrec,dist_current);
        img=img+imgmod;
        iter=iter+1;
        fprintf('iter %d: %g\n',iter,dist_current);        
    else
        notfinish=false;        
    end        
end
