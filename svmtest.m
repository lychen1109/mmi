function [ac,nSV]=svmtest(class,data,cvpa,thetaa)
%test the svm accuracy with k split

k=length(cvpa);
ac=zeros(k,1);
nSV=zeros(k,1);

for i=1:k    
    CVP=cvpa(i);
    dataTrain=data(CVP.training,:);    
    grpTrain=class(CVP.training);
    dataTest=data(CVP.test,:);
    grpTest=class(CVP.test);
    [modelstruct,accu,~]=mysvmfun(grpTrain,dataTrain,grpTest,dataTest,thetaa(i,:));
    nSV(i)=size(modelstruct.SVs,1);    
    Nc=length(modelstruct.Yc);    
    ac(i)=accu(1);
    fprintf('accuracy %g with nSV %d,bSV %d\n',ac(i),nSV(i),Nc);
end

fprintf('mean accuracy:%g (%g), avg nSV:%g (%g)\n',mean(ac),std(ac),mean(nSV),std(nSV));


    
