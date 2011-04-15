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
%datatrain=repmat(gt,n_train,1).*datatrain;
%datatest=repmat(gt,n_test,1).*datatest;

%calculate training matrix
ktrain=crossdist(datatrain,datatrain,gt);
ktrain=exp(-ktrain);

C=2^theta(1);
cmd=['-c ' num2str(C) ' -t 4'];
model=svmtrain(labeltrain,[(1:n_train)' ktrain],cmd);
modelstruct=rowmodelparse(model,datatrain,C);

svidx=full(model.SVs);
datasv=datatrain(svidx,:);
ktest2=crossdist(datatest,datasv,gt);
ktest=zeros(n_test,n_train);
ktest(:,svidx)=ktest2;
ktest=exp(-ktest);

[~,accu,dvalues]=svmpredict(labeltest,[(1:n_test)' ktest],model);
