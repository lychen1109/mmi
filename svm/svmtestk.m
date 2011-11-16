function ac=svmtestk(label,data,rangec,rangeg)
%test accuracy of a set of splits

ac=zeros(1,5);
cvpk=cvpartition(label,'kfold',5);

for i=1:5    
    dataTrain=data(cvpk.training(i),:);
    labelTrain=label(cvpk.training(i));
    dataTest=data(cvpk.test(i),:);
    labelTest=label(cvpk.test(i));
    thetas=svmgrid2(labelTrain,dataTrain,rangec,rangeg);
    if size(thetas,1)>1
        theta=median(thetas);
    else
        theta=thetas;
    end
    fprintf('parameter used for split %d: (%d,%d)\n',i,theta);
    [~,accu]=mysvmfun(labelTrain,dataTrain,labelTest,dataTest,theta);
    ac(i)=accu(1);
    fprintf('accuracy of set %d is %g\n',i,ac(i));
end

ac=mean(ac);
