function grid=smoothcvgrid(grpTrain,dataTrain,rangec,rangeg)
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
    [A,B]=logistregdirect(grpTrain,dvalues);
    cv(i)=smootherror(grpTrain,dvalues,A,B);
end
t=toc;
fprintf('param search finished in %g sec\n',t);

cv=reshape(cv,ng,nc)';
grid=zeros(nc+1,ng+1);
grid(2:nc+1,1)=rangec;
grid(1,2:ng+1)=rangeg;
grid(2:nc+1,2:ng+1)=cv;

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


