function err=adaboosttest(data,label,holdoutCVP)
% a test function about adaboost

dataTrain=data(holdoutCVP.training,:);
labelTrain=label(holdoutCVP.training,:);
dataTest=data(holdoutCVP.test,:);
labelTest=label(holdoutCVP.test,:);
test_n=size(labelTest,1);
max_classifier_n=49;
err=zeros(1,max_classifier_n);

for i=1:max_classifier_n
    adaboost_model=ADABOOST_tr(@threshold_tr,@threshold_te,dataTrain,labelTrain,i);
    [~,hits]=ADABOOST_te(adaboost_model,@threshold_te,dataTest,labelTest);
    err(i)=(test_n-hits)/test_n;
    fprintf('error of %d weak classifiers is %g\n',i,err(i));
end

