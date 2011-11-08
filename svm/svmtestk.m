function ac=svmtestk(label,data,cvpk,theta)
%test accuracy of a set of splits

ac=zeros(5,1);

for i=1:5    
    dataTrain=data(cvpk.training(i),:);
    labelTrain=label(cvpk.training(i));
    dataTest=data(cvpk.test(i),:);
    labelTest=label(cvpk.test(i));
    [~,accu]=mysvmfun(labelTrain,dataTrain,labelTest,dataTest,theta);
    ac(i)=accu(1);
    fprintf('accuracy of set %d is %g\n',i,ac(i));
end
