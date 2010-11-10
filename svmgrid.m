function [bestc,bestg,bestcv]=svmgrid(dataTrain,grpTrain,rangec,rangeg)
%parameter selection

if nargin<4
    rangec=-5:2:13;
    rangeg=5:-2:-15;
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
    cmd=['-v 5 -c ' num2str(2^log2c) ' -g ' num2str(2^log2g)];
    cv=svmtrain(grpTrain,dataTrain,cmd);    
    cvidx(i)=cv;
    %fprintf('%g %g %g (best c=%g, g=%g, rate=%g)\n',log2c,log2g,cv,bestc,bestg,bestcv);    
end

[~,I]=max(cvidx);
bestlog2c=cgidx(I,1);
bestlog2g=cgidx(I,2);

%fine search
fine_range=-1.5:0.5:1.5;
finesearchnum=length(fine_range)^2;
cgidx2=zeros(finesearchnum,2);
cvidx2=zeros(finesearchnum,1);
idx=0;

for i=bestlog2c+fine_range
    for j=bestlog2g+fine_range
        idx=idx+1;
        cgidx2(idx,:)=[i j];
    end
end
        
parfor i=1:finesearchnum
    param=cgidx2(i,:);
    log2c=param(1);
    log2g=param(2);
    cmd=['-v 5 -c ' num2str(2^log2c) ' -g ' num2str(2^log2g)];
    cv=svmtrain(grpTrain,dataTrain,cmd);
    cvidx2(i)=cv;
    %fprintf('2: %g %g %g (best c=%g, g=%g, rate=%g)\n',log2c,log2g,cv,bestc,bestg,bestcv);    
end
[bestcv,I]=max(cvidx2);
bestlog2c=cgidx2(I,1);
bestlog2g=cgidx2(I,2);
bestc=2^bestlog2c;
bestg=2^bestlog2g;


