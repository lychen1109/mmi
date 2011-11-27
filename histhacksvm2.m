function [img,doutrec,returntype]=histhacksvm2(img,tdout,model,range)
%modify image in pixel domain, with SVM soft output as likelihood

bdctimg=blkproc(img,[8 8],@dct2);
bdctimg=round(bdctimg);
bdctsign=sign(bdctimg);
bdctsign(bdctsign==0)=1;
bdctimg=abs(bdctimg);
T=3;
N=1000;
nbatch=10;%number of bdct coeff used in one iteration
tm=tpm1(bdctimg,T);
[~,~,dout_ori]=svmpredict(0,svmrescale(tm(:)',range),model);
doutrec=dout_ori;%record dout in every iteration
if dout_ori>tdout
    fprintf('dout is %g, already larer than tdout %g\n',dout_ori,tdout);
    returntype=0;%no changes
    return;
else
    fprintf('dout_ori is %g, tdout is %g\n',dout_ori,tdout);
end
iter=0;
notfinish=true;

while notfinish      
    flagstruct=flagcreation(img,model,range,tdout,N);
    coefidx=flagstruct.coefidx;
    flags=flagstruct.flags;
    moddout=flagstruct.moddout;
    coefidx=coefidx(moddout>0);
    flags=flags(moddout>0);
    moddout=moddout(moddout>0);
    M=size(flags,1);
    
    [~,sortedidx]=sort(moddout,1,'descend');
    bdctmod=zeros(size(img));
    dout_current=doutrec(end);
    modidx=1;
    while dout_current<=doutrec(end) && modidx+nbatch-1<=M
        for i=modidx:modidx+nbatch-1
            [sj,sk]=ind2sub(size(img),coefidx(sortedidx(i)));
            bdctmod(sj,sk:sk+2)=bdctmod(sj,sk:sk+2)+flags(sortedidx(i),:).*bdctsign(sj,sk:sk+2);
        end
        imgmod=blkproc(bdctmod,[8 8],@idct2);
        imgmod=round(imgmod);
        dout_current=imgmodeltest(img+imgmod,model,range);
        modidx=modidx+nbatch;
    end    
    
    if dout_current>doutrec(end) 
        if dout_current<tdout || (dout_current>=tdout && ((dout_current-tdout)<(tdout-doutrec(end))))
            doutrec=cat(1,doutrec,dout_current);
            img=img+imgmod;
            iter=iter+1;
            fprintf('iter %d: %g\n',iter,dout_current);
            if dout_current>=tdout
                notfinish=false;
                returntype=1;
            end
        else
            notfinish=false;
            returntype=2;%over modified
        end
    else
        notfinish=false;
        returntype=3;%cannot modify anymore
    end        
end
