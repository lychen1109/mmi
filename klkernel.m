function [K_train,K_test]=klkernel(datatrain,datatest,g,type)
%return training and test kernel matrix

n_train=size(datatrain,1);
n_test=size(datatest,1);
K_train=zeros(n_train,n_train);
K_test=zeros(n_test,n_train);

for i=1:n_train
    for j=1:n_train
        kld=kl_div(datatrain(i,:),datatrain(j,:),type);
        K_train(i,j)=exp(-g*kld);
    end
end

for i=1:n_test
    for j=1:n_train
        kld=kl_div(datatest(i,:),datatrain(j,:),type);
        K_test(i,j)=exp(-g*kld);
    end
end
