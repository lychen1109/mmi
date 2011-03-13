function [model,accu,dvalues]=rowsvmfun(labeltrain,datatrain,labeltest,datatest,theta)
%every row has its own gamma

n_train=length(labeltrain);
n_test=length(labeltest);
Ktrain=zeros(n_train,n_train);
Ktest=zeros(n_test,n_train);
for i=1:n_train
    for j=1:n_train
        Ktrain(i,j)=exp(-dist(datatrain(i,:),datatrain(j,:),theta));
    end
end

for i=1:n_test
    for j=1:n_train
        Ktest(i,j)=exp(-dist(datatest(i,:),datatrain(j,:),theta));
    end
end

cmd=['-c ' num2str(2^theta(1)) ' -t 4'];
model=svmtrain(labeltrain,[(1:n_train)' Ktrain],cmd);
[~,accu,dvalues]=svmpredict(labeltest,[(1:n_test)' Ktest],model);

function d=dist(x,y,theta)
%distance of sample pairs
d=0;
for i=1:9
    t=false(9,9);
    t(i,:)=true(1,9);
    d=d+theta(i+1)*norm(x(t(:))-y(t(:)))^2;
end
