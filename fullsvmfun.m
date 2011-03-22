function [modelstruct,accu,dvalues]=fullsvmfun(labeltrain,datatrain,labeltest,datatest,theta)
%full SVM classifier

n_train=length(labeltrain);
n_test=length(labeltest);
Ktrain=zeros(n_train,n_train);
Ktest=zeros(n_test,n_train);
C=2^theta(1);

tic;
for i=1:n_train
    for j=1:n_train
        Ktrain(i,j)=fullrbfdist(datatrain(i,:),datatrain(j,:),theta);
    end
end
Ktrain=exp(-Ktrain);
t=toc;
fprintf('training kernel calculated in %g sec\n',t);

cmd=['-c ' num2str(C) ' -t 4'];
model=svmtrain(labeltrain,[(1:n_train)' Ktrain],cmd);
modelstruct=rowmodelparse(model,datatrain,C);

datasv=modelstruct.SVs;
nSV=model.totalSV;
svidx=full(model.SVs);
Ktest1=zeros(n_test,nSV);

tic;
for i=1:n_test
    for j=1:nSV
        Ktest1(i,j)=fullrbfdist(datatest(i,:),datasv(j,:),theta);
    end
end
Ktest(:,svidx)=Ktest1;
Ktest=exp(-Ktest);
t=toc;
fprintf('test kernel calculated in %g sec\n',t);

[~,accu,dvalues]=svmpredict(labeltest,[(1:n_test)' Ktest],model);
