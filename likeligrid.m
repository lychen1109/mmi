function [bestc,bestg,bestcv,cv]=likeligrid(grpTrain,dataTrain,rangec,rangeg)
%parameter selection

nc=length(rangec);
ng=length(rangeg);
NP=nc*ng;
fprintf('evaluating %d sets of params\n',NP);
cv=zeros(NP,1);
params=zeros(NP,2);
cvp=cvpartition(grpTrain,'kfold',5);

for i=1:nc
    wr=(i-1)*ng+(1:ng);%working range
    params(wr,1)=rangec(i);
    params(wr,2)=rangeg;
end

tic;
parfor i=1:NP
    [log2c,log2g]=paramsplit(params(i,:));    
    dvalues=getdvalues(grpTrain,dataTrain,cvp,[log2c,log2g]);
    [~,~,cv(i)]=logistreg(grpTrain,dvalues);
end
cv=-cv;
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

function dvalues=getdvalues(grpTrain,dataTrain,cvp,theta)

K=cvp.NumTestSets;
dvalues=zeros(size(grpTrain));
for k=1:K
    [~,~,dvalues(cvp.test(k))]=mysvmfun(grpTrain(cvp.training(k)),dataTrain(cvp.training(k),:),grpTrain(cvp.test(k)),dataTrain(cvp.test(k),:),theta);
end


