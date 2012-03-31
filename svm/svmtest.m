function ac=svmtest(class,data,ratio,k,rangec,rangeg,thetai)
%test the svm accuracy with k split
%ratio is the percentage of training samples

ac=zeros(k,3);
N=size(class,1);
ntest=round(N*(1-ratio));
fprintf('test sample size is %d\n',ntest);
if nargin<5
    rangec=0:2:12;
    rangeg=-7:2:3;
end

for i=1:k    
    CVP=cvpartition(class,'holdout',ntest);
    dataTrain=data(CVP.training,:);    
    grpTrain=class(CVP.training);
    dataTest=data(CVP.test,:);
    grpTest=class(CVP.test);
    if nargin<7
        thetas=svmgrid2(grpTrain,dataTrain,rangec,rangeg);
        %[thetas,thresholds]=svmgridtp(grpTrain,dataTrain,0:2:12,-6:2:6);
        [~,~,dvalues]=mysvmfun(grpTrain,dataTrain,grpTest,dataTest,thetas(1,:));
    else
        [~,~,dvalues]=mysvmfun(grpTrain,dataTrain,grpTest,dataTest,thetai);
    end
    predict=ones(size(grpTest));
    predict(dvalues<0)=0;
    ac(i,1)=sum(predict==grpTest)/length(grpTest);
    ac(i,2)=sum(grpTest==0 & predict==grpTest)/sum(grpTest==0);
    ac(i,3)=sum(grpTest==1 & predict==grpTest)/sum(grpTest==1);
    fprintf('accuracy %g tp %g tn %g\n',ac(i,:)');
end



    
