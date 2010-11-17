function [bestc,bestg,bestcv]=svmgrid(dataTrain,grpTrain,display,type,rangec,rangeg)
%parameter selection

if nargin<4
    type=2;
end

if nargin<5
    rangec=-5:2:15;
    rangeg=3:-2:-15;
end

searchnum=length(rangec)*length(rangeg);
cgidx=zeros(searchnum,2);
cvidx=zeros(searchnum,1);
idx=0;%index of cgidx
for i=rangec
    for j=rangeg
        idx=idx+1;
        cgidx(idx,:)=[i j];
    end
end
        
parfor i=1:searchnum
    param=cgidx(i,:);
    log2c=param(1);
    log2g=param(2);
    if type==0
        cmd=['-v 5 -c ' num2str(2^log2c) ' -t 0'];
    else
        cmd=['-v 5 -c ' num2str(2^log2c) ' -g ' num2str(2^log2g)];
    end
    cv=svmtrain(grpTrain,dataTrain,cmd);    
    cvidx(i)=cv;
    if display>0
        fprintf('%g %g %g\n',log2c,log2g,cv);
    end
end

[bestcv,I]=max(cvidx);
bestlog2c=cgidx(I,1);
bestlog2g=cgidx(I,2);

bestc=2^bestlog2c;
bestg=2^bestlog2g;


