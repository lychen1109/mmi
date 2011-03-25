function [bestc,bestg,bestcv,cv]=svmgrid(grpTrain,dataTrain,rangec,rangeg)
%parameter selection

nc=length(rangec);
ng=length(rangeg);
NP=nc*ng;
fprintf('evaluating %d sets of params\n',NP);
cv=zeros(NP,1);
params=zeros(NP,2);

for i=1:nc
    wr=(i-1)*ng+(1:ng);%working range
    params(wr,1)=rangec(i);
    params(wr,2)=rangeg;
end

tic;
parfor i=1:NP
    [log2c,log2g]=paramsplit(params(i,:));    
    cmd=['-v 5 -c ' num2str(2^log2c) ' -g ' num2str(2^log2g)];
    cv(i)=svmtrain(grpTrain,dataTrain,cmd);
end
t=toc;
fprintf('param search finished in %g sec\n',t);

[bestcv,I]=max(cv);
[log2c,log2g]=paramsplit(params(I,:));

bestc=2^log2c;
bestg=2^log2g;

cv=reshape(cv,ng,nc)';

function [log2c,log2g]=paramsplit(prow)
%split params

log2c=prow(1);
log2g=prow(2);



