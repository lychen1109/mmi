function output=flagcreation(img,model,range,tdout,N)
%create location and flags that can improve the image svm output
%also output the potential improvement
%tdout: target svm output

coefidx=randperm(128^2-256);
coefidx=coefidx(1:N);
flags=zeros(N,3);
moddout=zeros(N,1);
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

for i=1:N
    [sj,sk]=ind2sub(size(bdctimg),coefidx(i));
    %     y1=threshold(bdctimg(sj,sk)-bdctimg(sj,sk+1),T)+T+1;
    %     y2=threshold(bdctimg(sj,sk+1)-bdctimg(sj,sk+2),T)+T+1;
    dout=zeros(1,26);
    dout(1:26)=-inf;
    for j=1:26
        if ~any(bdctimg(sj,sk+(0:2))+flagstr(j,:)<0)
            tmnew=tmmod(bdctimg,tm,sj,sk,flagstr(j,:),T);
            [~,~,dout(j)]=svmpredict(0,svmrescale(tmnew(:)',range),model);
        end
    end
    [maxdout,maxdoutidx]=max(dout);
    flags(i,:)=flagstr(maxdoutidx,:);
    moddout(i)=maxdout-dout_ori;    
end

output.coefidx=coefidx;
output.flags=flags;
output.moddout=moddout;

    