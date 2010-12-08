function [m,s]=svmtest(class,data,svmstr,k,n_test)
%test the svm accuracy with k outer loop

ac=zeros(k,1);
for i=1:k    
    CVP=cvpartition(class,'holdout',n_test);
    dataTrain=data(CVP.training,:);
    grpTrain=class(CVP.training);    
    model=svmtrain(grpTrain,dataTrain,svmstr);    
    dataTest=data(CVP.test,:);
    grpTest=class(CVP.test);
    predict=svmpredict(grpTest,dataTest,model);    
    ac(i)=sum(predict==grpTest)/n_test;
    disp(ac(i));
end
m=mean(ac);
s=std(ac);

    
