function [ac,tp,tn]=svmtestk(label,data,rangec,rangeg)
%test accuracy of a set of splits

cvpk=cvpartition(label,'kfold',5);
predict=zeros(size(label));

for i=1:5    
    dataTrain=data(cvpk.training(i),:);
    labelTrain=label(cvpk.training(i));
    dataTest=data(cvpk.test(i),:);
    labelTest=label(cvpk.test(i));
    thetas=svmgrid2(labelTrain,dataTrain,rangec,rangeg);    
    fprintf('parameter used for split %d: (%d,%d)\n',i,thetas(1,:));
    predict(cvpk.test(i))=mysvmfun(labelTrain,dataTrain,labelTest,dataTest,thetas(1,:));    
end

N=length(label);
ac=sum(predict==label)/N;
tp=sum(label==1 & predict==label)/sum(label==1);
tn=sum(label==0 & predict==label)/sum(label==0);
