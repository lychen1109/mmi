function [ac,nSV]=svmtest(class,data,cvpa,thetaa,mysvmfun)
%test the svm accuracy with k outer loop

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
    
%     if type==4
%         model=svmtrain(grpTrain,[(1:n_train)' dataTrain*kernel*dataTrain'],svmstr);
%         [~,accu,~]=svmpredict(grpTest,[(1:n_test)' dataTest*kernel*dataTrain'],model);
%     else
%         model=svmtrain(grpTrain,dataTrain,svmstr);
%         [~,accu,~]=svmpredict(grpTest,dataTest,model);
%     end
    nSV(i)=size(modelstruct.SVs,1);    
    Nc=length(modelstruct.Yc);    
    ac(i)=accu(1);
    fprintf('accuracy %g with nSV %d,bSV %d\n',ac(i),nSV(i),Nc);
end

fprintf('mean accuracy:%g, std:%g, avg nSV:%g (%g)\n',mean(ac),std(ac),mean(nSV),std(nSV));
fprintf('median value of SVM parameters are:\n');
disp(2.^median(thetaa));

    
