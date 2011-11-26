function ximg=histhacksvm2(img,tdout,model,range)
%modify image in pixel domain, with SVM soft output as likelihood

ximg=img;
bdctimg=blkproc(img,[8 8],@dct2);
bdctsign=sign(bdctimg);
bdctimg=abs(round(bdctimg));
T=3;
nbatch=10;%number of bdct coeff used in one iteration
tm=tpm1(bdctimg,T);
[~,~,dout_ori]=svmpredict(0,svmrescale(tm(:)',range),model);
if dout_ori>tdout
    return;
end
iter=0;
notfinish=true;
doutrec=dout_ori;%record dout in every iteration

while notfinish
    iter=iter+1;
    flagstruct=flagcreation(img,model,range,tdout);
    coefidx=flagstruct.coefidx;
    flags=flagstruct.flags;
    moddout=flagstruct.moddout;
    [~,sortedidx]=sort(moddout,1,'descend');
    bdctmod=zeros(size(img));
    if length(coefidx)<nbatch
        fprintf('number of coef to modify is less than batch size.\n');
    end
    for i=1:nbatch
        [sj,sk]=ind2sub(size(img),coefidx(sortedidx(i)));
        bdctmod(sj,sk:sk+2)=bdctmod(sj,sk:sk+2)+flags(sortedidx(i),:).*bdctsign(sj,sk:sk+2);
    end
    imgmod=blkproc(bdctmod,[8 8],@idct2);
    imgmod=round(imgmod);
    dout_current=imgmodeltest(img+imgmod,model,range);
    if dout_current>doutrec(iter) 
        if dout_current<tdout || (dout_current>=tdout && ((dout_current-tdout)<(tdout-doutrec(iter))))
            doutrec=cat(1,doutrec,dout_current);
            img=img+imgmod;
            if dout_current>=tdout
                notfinish=false;
            end
        else
            notfinish=false;
        end
    else
        notfinish=false;
    end        
end