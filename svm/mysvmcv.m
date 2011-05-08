function [mac,mnsv,mbsv]=mysvmcv(label,feat,theta)
%do cross validation with mysvmfun

cvp=cvpartition(label,'kfold',5);
ac=zeros(5,1);
nsv=zeros(5,1);
bsv=zeros(5,1);

for i=1:5
    labeltrain=label(cvp.training(i));
    datatrain=feat(cvp.training(i),:);
    labeltest=label(cvp.test(i));
    datatest=feat(cvp.test(i),:);
    [modelstruct,accu]=mysvmfun(labeltrain,datatrain,labeltest,datatest,theta);
    ac(i)=accu(1);
    nsv(i)=size(modelstruct.SVs,1);
    bsv(i)=size(modelstruct.SVsc,1);
end
mac=mean(ac);
mnsv=mean(nsv);
mbsv=mean(bsv);
