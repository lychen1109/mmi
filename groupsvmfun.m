function [modelstruct,accu,dvalues]=groupsvmfun(labeltrain,datatrain,labeltest,datatest,group,theta)
%SVM wrapper for group gammas

n_group=max(group);
gt=zeros(size(group));
for i=1:n_group
    gt(group==i)=theta(i+1);
end
gt=sqrt(2.^gt);

%rescale samples
n_train=length(labeltrain);
n_test=length(labeltest);
datatrain=repmat(gt,n_train,1).*datatrain;
datatest=repmat(gt,n_test,1).*datatest;

C=2^theta(1);
cmd=['-c ' num2str(C) '-g 1'];
model=svmtrain(labeltrain,datatrain,cmd);
[~,accu,dvalues]=svmpredict(labeltest,datatest,model);
modelstruct=modelparse(model,C);
