function [ac]=svmtestl(label,data,cvpa,theta)
%test accuracy of a set of splits with linear kernel

k=length(cvpa);
ac=zeros(k,1);
cmd=['-t 0 -c ' num2str(2^theta)];

for i=1:k
    cvp=cvpa(i);
    dataTrain=data(cvp.training,:);
    labelTrain=label(cvp.training);
    dataTest=data(cvp.test,:);
    labelTest=label(cvp.test);
    model=svmtrain(labelTrain,dataTrain,cmd);
    [~,accu]=svmpredict(labelTest,dataTest,model);
    ac(i)=accu(1);
    fprintf('accuracy of set %d is %g\n',i,ac(i));
end
