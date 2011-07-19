function [ac]=svmtest2(label,data,cvpa,theta)
%test accuracy of a set of splits

k=length(cvpa);
ac=zeros(k,1);

for i=1:k
    cvp=cvpa(i);
    dataTrain=data(cvp.training,:);
    labelTrain=label(cvp.training);
    dataTest=data(cvp.test,:);
    labelTest=label(cvp.test);
    [~,accu]=mysvmfun(labelTrain,dataTrain,labelTest,dataTest,theta);
    ac(i)=accu(1);
    fprintf('accuracy of set %d is %g\n',i,ac(i));
end
