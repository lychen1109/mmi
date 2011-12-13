function [ac,tp,tn]=svmtest(class,data,cvpa)
%test the svm accuracy with k split

k=length(cvpa);
ac=zeros(k,1);
tp=zeros(k,1);
tn=zeros(k,1);

for i=1:k    
    CVP=cvpa{i};
    dataTrain=data(CVP.training,:);    
    grpTrain=class(CVP.training);
    dataTest=data(CVP.test,:);
    grpTest=class(CVP.test);
    thetas=svmgrid2(grpTrain,dataTrain,0:2:12,-6:2:6);
    [predict]=mysvmfun(grpTrain,dataTrain,grpTest,dataTest,thetas(1,:));      
    ac(i)=sum(predict==grpTest)/length(grpTest);
    tp(i)=sum(grpTest==0 & predict==grpTest)/sum(grpTest==0);
    tn(i)=sum(grpTest==1 & predict==grpTest)/sum(grpTest==1);
    fprintf('accuracy %g tp %g tn %g\n',ac(i),tp(i),tn(i));
end

fprintf('final accuracy: %g (%g), tp: %g (%g), tn:%g (%g)\n',mean(ac),std(ac),mean(tp),std(tp),mean(tn),std(tn));


    
