function ac=svmtest(class,data,theta,mysvmfun,k,n_test)
%test the svm accuracy with k outer loop

ac=zeros(k,1);
nSV=zeros(k,1);
C=2^theta(1);
fprintf('trained with C=%g\n',C);
%svmstr=['-c ' num2str(c) ' -g ' num2str(g) ' -t ' num2str(type)];
for i=1:k    
    CVP=cvpartition(class,'holdout',n_test);
    dataTrain=data(CVP.training,:);    
    grpTrain=class(CVP.training);
    dataTest=data(CVP.test,:);
    grpTest=class(CVP.test);
    [modelstruct,accu,~]=mysvmfun(grpTrain,dataTrain,grpTest,dataTest,theta);
    
%     if type==4
%         model=svmtrain(grpTrain,[(1:n_train)' dataTrain*kernel*dataTrain'],svmstr);
%         [~,accu,~]=svmpredict(grpTest,[(1:n_test)' dataTest*kernel*dataTrain'],model);
%     else
%         model=svmtrain(grpTrain,dataTrain,svmstr);
%         [~,accu,~]=svmpredict(grpTest,dataTest,model);
%     end
    nSV(i)=size(modelstruct.SVs,1);    
    Nc=length(modelstruct.Yc);
    alphau=modelstruct.alphau;
    ac(i)=accu(1);
    fprintf('accuracy %g with nSV %d,bSV %d, max unbounded SV=%g\n',ac(i),nSV(i),Nc,max(alphau));
end

fprintf('mean accuracy:%g, std:%g, avg nSV:%g\n',mean(ac),std(ac),mean(nSV));

    
