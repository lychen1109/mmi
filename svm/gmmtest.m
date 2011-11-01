function [ac]=gmmtest(label,data,cvpa,num)
%test accuracy of a set of splits

k=length(cvpa);
ac=zeros(k,1);

parfor i=1:k
    cvp=cvpa(i);
    [labelTrain,dataTrain,labelTest,dataTest]=datasplit(label,data,cvp);
    ac(i)=gmmclassify(labelTrain,dataTrain,labelTest,dataTest,num);    
    fprintf('accuracy of set %d is %g\n',i,ac(i));
end

function [labelTrain,dataTrain,labelTest,dataTest]=datasplit(label,data,cvp)
dataTrain=data(cvp.training,:);
labelTrain=label(cvp.training);
dataTest=data(cvp.test,:);
labelTest=label(cvp.test);
