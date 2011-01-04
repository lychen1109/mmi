function [m,s]=svmtest(class,data,c,g,type,k,n_test,kernel)
%test the svm accuracy with k outer loop

ac=zeros(k,1);
svmstr=['-c ' num2str(c) ' -g ' num2str(g) ' -t ' num2str(type)];
for i=1:k    
    CVP=cvpartition(class,'holdout',n_test);
    dataTrain=data(CVP.training,:);
    n_train=size(dataTrain,1);
    grpTrain=class(CVP.training);
    dataTest=data(CVP.test,:);
    grpTest=class(CVP.test);
    
    if type==4
        model=svmtrain(grpTrain,[(1:n_train)' dataTrain*kernel*dataTrain'],svmstr);
        predict=svmpredict(grpTest,[(1:n_test)' dataTest*kernel*dataTrain'],model);
    else
        model=svmtrain(grpTrain,dataTrain,svmstr);
        predict=svmpredict(grpTest,dataTest,model);
    end
    ac(i)=sum(predict==grpTest)/n_test;
    disp(ac(i));
end
m=mean(ac);
s=std(ac);

    
