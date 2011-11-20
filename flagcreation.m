function output=flagcreation(img,model,range,tdout)
%create location and flags that can improve the image svm output
%also output the potential improvement
%tdout: target svm output

coeftomod=false(128^2-256,1);
coefidx=(1:128^2-256)';
flags=zeros(128^2-256,3);
moddout=zeros(128^2-256,1);
T=3;

bdctimg=blkproc(img,[8 8],@dct2);
bdctimg=abs(round(bdctimg));
tm=tpm1(bdctimg,3);
[~,~,dout_ori]=svmpredict(0,svmrescale(tm(:)',range),model);
if dout_ori>tdout
    fprintf('the image looks authentic enough. dout_ori=%g\n',dout_ori);
    output=[];
    return;
end

%construct flagstr
flagstr=zeros(26,3);
idx=0;
for i=-1:1
    for j=-1:1
        for k=-1:1
            if any([i j k])
                idx=idx+1;
                flagstr(idx,:)=[i j k];
            end
        end
    end
end

de=svmgrad(model,svmrescale(tm(:)',range));

for i=1:128^2-256;
    [sj,sk]=ind2sub(size(bdctimg),i);
    y1=threshold(bdctimg(sj,sk)-bdctimg(sj,sk+1),T);
    y2=threshold(bdctimg(sj,sk+1)-bdctimg(sj,sk+2),T);
    deidx=sub2ind(size(tm),y1,y2);
    if de(deidx)<0
        dout=zeros(1,26);
        dout(1:26)=-inf;
        for j=1:26
            if ~any(bdctimg(sj,sk+(0:2))+flagstr(j,:)<0)
                tmnew=tmmod(bdctimg,tm,sj,sk,flagstr(j,:),T);
                [~,~,dout(j)]=svmpredict(0,svmrescale(tmnew(:)',range),model);
            end
        end
        [maxdout,maxdoutidx]=max(dout);
        if maxdout>dout_ori
            coeftomod(i)=true;
            flags(i,:)=flagstr(maxdoutidx,:);
            moddout(i)=maxdout-dout_ori;
        end
    end
end

output.coefidx=coefidx(coeftomod);
output.flags=flags(coeftomod,:);
output.moddout=moddout(coeftomod);



    