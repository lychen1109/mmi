function [ac,tp,tn]=svmtest(class,data,ratio)
%test the svm accuracy with k split
%ratio is the percentage of training samples

k=20;
ac=zeros(k,1);
tp=zeros(k,1);
tn=zeros(k,1);
N=size(class,1);
ntest=round(N*(1-ratio));
fprintf('test sample size is %d\n',ntest);

for i=1:k    
    CVP=cvpartition(class,'holdout',ntest);
    dataTrain=data(CVP.training,:);    
    grpTrain=class(CVP.training);
    dataTest=data(CVP.test,:);
    grpTest=class(CVP.test);
    thetas=svmgrid2(grpTrain,dataTrain,0:2:12,-6:2:6);
    %[thetas,thresholds]=svmgridtp(grpTrain,dataTrain,0:2:12,-6:2:6);
    [~,~,dvalues]=mysvmfun(grpTrain,dataTrain,grpTest,dataTest,thetas(1,:));
    predict=ones(size(grpTest));
    predict(dvalues<0)=0;
    ac(i)=sum(predict==grpTest)/length(grpTest);
    tp(i)=sum(grpTest==0 & predict==grpTest)/sum(grpTest==0);
    tn(i)=sum(grpTest==1 & predict==grpTest)/sum(grpTest==1);
    fprintf('accuracy %g tp %g tn %g\n',ac(i),tp(i),tn(i));
end

fprintf('final accuracy: %g (%g), tp: %g (%g), tn:%g (%g)\n',mean(ac),std(ac),mean(tp),std(tp),mean(tn),std(tn));


    
