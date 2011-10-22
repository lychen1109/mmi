function [ac]=gmmtest(label,data,cvpa,num)
%test accuracy of a set of splits

k=length(cvpa);
ac=zeros(k,1);

for i=1:k
    cvp=cvpa(i);
    dataTrain=data(cvp.training,:);
    labelTrain=label(cvp.training);
    dataTest=data(cvp.test,:);
    labelTest=label(cvp.test);
    ac(i)=gmmclassify(labelTrain,dataTrain,labelTest,dataTest,num);    
    fprintf('accuracy of set %d is %g\n',i,ac(i));
end
