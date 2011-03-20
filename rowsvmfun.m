function [modelstruct,accu,dvalues]=rowsvmfun(labeltrain,datatrain,labeltest,datatest,theta)
%every row has its own gamma

n_train=length(labeltrain);
n_test=length(labeltest);
Ktrain=zeros(n_train,n_train);
Ktest=zeros(n_test,n_train);
C=2^theta(1);

tic;
for i=1:n_train
    datatraini=datatrain(i,:);
    Ktrainrow=zeros(1,n_train);
    for j=1:n_train
        Ktrainrow(j)=rowrbfdist(datatraini,datatrain(j,:),theta);
    end
    Ktrain(i,:)=Ktrainrow;
end
Ktrain=exp(-Ktrain);
t=toc;
fprintf('kernel of training calculated in %d sec\n',t);

cmd=['-c ' num2str(C) ' -t 4'];
model=svmtrain(labeltrain,[(1:n_train)' Ktrain],cmd);
modelstruct=rowmodelparse(model,datatrain,C);

datasv=modelstruct.SVs;
nSV=model.totalSV;

tic;
for i=1:n_test
    datatesti=datatest(i,:);
    Ktestrow=zeros(1,nSV);
    for j=1:nSV        
        Ktestrow(j)=rowrbfdist(datatesti,datasv(j,:),theta);        
    end
    Ktest(i,SVs)=Ktestrow;
end
Ktest=exp(-Ktest);
t=toc;
fprintf('kernel of test calculated in %d sec\n',t);

[~,accu,dvalues]=svmpredict(labeltest,[(1:n_test)' Ktest],model);


