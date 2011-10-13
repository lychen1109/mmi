function [ac]=lintest(label,data,cvpa,type)
%test accuracy of a set of splits with linear classifier

k=length(cvpa);
ac=zeros(k,1);

for i=1:k
    cvp=cvpa(i);
    dataTrain=data(cvp.training,:);
    labelTrain=label(cvp.training);
    dataTest=data(cvp.test,:);
    labelTest=label(cvp.test);    
    accu=linclassify(labelTrain,dataTrain,labelTest,dataTest,type);
    ac(i)=accu;
    fprintf('accuracy of set %d is %g\n',i,ac(i));
end
