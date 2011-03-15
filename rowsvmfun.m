function [model,accu,dvalues]=rowsvmfun(labeltrain,datatrain,labeltest,datatest,theta)
%every row has its own gamma

n_train=length(labeltrain);
n_test=length(labeltest);
Ktrain=zeros(n_train,n_train);
Ktest=zeros(n_test,n_train);

tic;
for i=1:n_train
    datatraini=datatrain(i,:);
    Ktrainrow=zeros(1,n_train);
    parfor j=1:n_train
        Ktrainrow(j)=rowrbfdist(datatraini,datatrain(j,:),theta);
    end
    Ktrain(i,:)=Ktrainrow;
end
Ktrain=exp(-Ktrain);
t=toc;
fprintf('kernel of training calculated in %d sec\n',t);

tic;
for i=1:n_test
    datatesti=datatest(i,:);
    Ktestrow=zeros(1,n_train);
    parfor j=1:n_train
        Ktestrow(j)=rowrbfdist(datatesti,datatrain(j,:),theta);
    end
    Ktest(i,:)=Ktestrow;
end
Ktest=exp(-Ktest);
t=toc;
fprintf('kernel of test calculated in %d sec\n',t);

cmd=['-c ' num2str(2^theta(1)) ' -t 4'];
model=svmtrain(labeltrain,[(1:n_train)' Ktrain],cmd);
[~,accu,dvalues]=svmpredict(labeltest,[(1:n_test)' Ktest],model);


