function dvalues=imagemodtest(simg,output,model,range)
%test effect of bdct modification on pixel domain

coefidx=output.coefidx;
flags=output.flags;
moddout=output.moddout;
coefidx=coefidx(moddout>0);
flags=flags(moddout>0,:);
moddout=moddout(moddout>0);

N=size(flags,1);
step=5;
K=floor(N/step);
dvalues=zeros(K+1,1);
dvalues(1)=imgmodeltest(simg,model,range);

[~,sortedidx]=sort(moddout,1,'descend');
%sortedidx=randperm(length(moddout));
bdctarray=blkproc(simg,[8 8],@dct2);
bdctsign=sign(bdctarray);
bdctmod=zeros(size(simg));
iter=1;

for i=1:N
    [sj,sk]=ind2sub(size(simg),coefidx(sortedidx(i)));
    bdctmod(sj,sk:sk+2)=bdctmod(sj,sk:sk+2)+flags(sortedidx(i),:).*bdctsign(sj,sk:sk+2);
    if mod(i,step)==0
        iter=iter+1;
        fprintf('iter %d\n',iter-1);
        imgmod=blkproc(bdctmod,[8 8],@idct2);
        imgmod=round(imgmod);
        dvalues(iter)=imgmodeltest(simg+imgmod,model,range);
    end        
end





