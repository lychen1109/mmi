function [modelstruct,accu,dvalues]=rowsvmfun(labeltrain,datatrain,labeltest,datatest,theta)
%every row has its own gamma

n_train=length(labeltrain);
n_test=length(labeltest);
Ktrain=zeros(n_train,n_train);
Ktest=zeros(n_test,n_train);
C=2^theta(1);

tic;
for i=1:n_train-1    
    for j=i+1:n_train
        Ktrain(i,j)=rowrbfdist(datatrain(i,:),datatrain(j,:),theta);
    end    
end
Ktrain=Ktrain+Ktrain';
Ktrain=exp(-Ktrain);
t=toc;
fprintf('kernel of training calculated in %d sec\n',t);

cmd=['-c ' num2str(C) ' -t 4'];
model=svmtrain(labeltrain,[(1:n_train)' Ktrain],cmd);
modelstruct=rowmodelparse(model,datatrain,C);

datasv=modelstruct.SVs;
nSV=model.totalSV;
svidx=full(model.SVs);
Ktestsub=zeros(n_test,nSV);

tic;
for i=1:n_test    
    for j=1:nSV        
        Ktestsub(i,j)=rowrbfdist(datatest(i,:),datasv(j,:),theta);        
    end    
end
Ktest(:,svidx)=Ktestsub;
Ktest=exp(-Ktest);
t=toc;
fprintf('kernel of test calculated in %d sec\n',t);

[~,accu,dvalues]=svmpredict(labeltest,[(1:n_test)' Ktest],model);


