function [ac,nSV]=svmtest(class,data,cvpa)
%test the svm accuracy with k split

k=length(cvpa);
ac=zeros(k,1);
nSV=zeros(k,1);
thetas=zeros(5,2);

for i=1:5    
    CVP=cvpa(i);
    dataTrain=data(CVP.training,:);    
    grpTrain=class(CVP.training);
    dataTest=data(CVP.test,:);
    grpTest=class(CVP.test);
    thetas(i,:)=svmgrid(grpTrain,dataTrain,12:-1:0,-6:6);
    [modelstruct,accu,~]=mysvmfun(grpTrain,dataTrain,grpTest,dataTest,thetas(i,:));
    nSV(i)=size(modelstruct.SVs,1);    
    Nc=length(modelstruct.Yc);    
    ac(i)=accu(1);
    fprintf('accuracy %g with nSV %d,bSV %d\n',ac(i),nSV(i),Nc);
end

theta=median(thetas);
fprintf('thetas selected for the rests: C=%d, g=%d\n',theta(1),theta(2));
for i=6:k
    CVP=cvpa(i);
    dataTrain=data(CVP.training,:);    
    grpTrain=class(CVP.training);
    dataTest=data(CVP.test,:);
    grpTest=class(CVP.test);    
    [modelstruct,accu,~]=mysvmfun(grpTrain,dataTrain,grpTest,dataTest,theta);
    nSV(i)=size(modelstruct.SVs,1);    
    Nc=length(modelstruct.Yc);    
    ac(i)=accu(1);
    fprintf('accuracy %g with nSV %d,bSV %d\n',ac(i),nSV(i),Nc);
end

fprintf('mean accuracy:%g (%g), avg nSV:%g (%g)\n',mean(ac),std(ac),mean(nSV),std(nSV));


    
