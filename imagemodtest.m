function [imgmod]=imagemodtest(simg,output,N)
%test effect of bdct modification on pixel domain

coefidx=output.coefidx;
flags=output.flags;
moddout=output.moddout;

[~,sortedidx]=sort(moddout,1,'descend');
%sortedidx=randperm(length(moddout));
bdctarray=blkproc(simg,[8 8],@dct2);
bdctsign=sign(bdctarray);
bdctmod=zeros(size(simg));

for i=1:N
    [sj,sk]=ind2sub(size(simg),coefidx(sortedidx(i)));
    bdctmod(sj,sk:sk+2)=bdctmod(sj,sk:sk+2)+flags(sortedidx(i),:).*bdctsign(sj,sk:sk+2);
end
imgmod=blkproc(bdctmod,[8 8],@idct2);
imgmod=round(imgmod);
fprintf('modified coeff is %d\n',sum(sum(imgmod~=0)));



