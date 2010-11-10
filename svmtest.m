function [ac,c,g,cv]=svmtest(class,data,k)
%test the svm accuracy with k outer loop

ac=zeros(k,1);%classification of every loop
cv=zeros(k,1);%cross validation accuracy
c=zeros(k,1);
g=zeros(k,1);
for i=1:k
    holdoutCVP=cvpartition(class,'holdout',400);
    dataTrain=data(holdoutCVP.training,:);
    grpTrain=class(holdoutCVP.training,:);
    [c(i),g(i),cv(i)]=svmgrid(dataTrain,grpTrain);
    cmd=['-c ' num2str(c(i)) ' -g ' num2str(g(i))];
    model=svmtrain(grpTrain,dataTrain,cmd);
    
    dataTest=data(holdoutCVP.test,:);
    grpTest=class(holdoutCVP.test,:);
    grpPred=svmpredict(grpTest,dataTest,model);
    
    ac(i)=sum(grpPred~=grpTest)/400;
end

    
