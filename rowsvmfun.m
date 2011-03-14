function [model,accu,dvalues]=rowsvmfun(labeltrain,datatrain,labeltest,datatest,theta)
%every row has its own gamma

n_train=length(labeltrain);
n_test=length(labeltest);
Ktrain=zeros(n_train,n_train);
Ktest=zeros(n_test,n_train);
for i=1:n_train
    datatraini=datatrain(i,:);
    Ktrainrow=zeros(1,n_train);
    parfor j=1:n_train
        Ktrainrow(j)=exp(-rowrbfdist(datatraini,datatrain(j,:),theta));
    end
    Ktrain(i,:)=Ktrainrow;
end

for i=1:n_test
    datatesti=datatest(i,:);
    Ktestrow=zeros(1,n_train);
    parfor j=1:n_train
        Ktestrow(j)=exp(-rowrbfdist(datatesti,datatrain(j,:),theta));
    end
    Ktest(i,:)=Ktestrow;
end

cmd=['-c ' num2str(2^theta(1)) ' -t 4'];
model=svmtrain(labeltrain,[(1:n_train)' Ktrain],cmd);
[~,accu,dvalues]=svmpredict(labeltest,[(1:n_test)' Ktest],model);


