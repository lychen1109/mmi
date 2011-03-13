function svmtest(class,data,c,g,type,k,n_test,kernel)
%test the svm accuracy with k outer loop

ac=zeros(k,1);
nSV=zeros(k,1);
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
        [~,accu,~]=svmpredict(grpTest,[(1:n_test)' dataTest*kernel*dataTrain'],model);
    else
        model=svmtrain(grpTrain,dataTrain,svmstr);
        [~,accu,~]=svmpredict(grpTest,dataTest,model);
    end
    nSV(i)=model.totalSV;
    ac(i)=accu(1);
    fprintf('accuracy %g with nSV %d\n',accu(1),model.totalSV);
end

fprintf('mean accuracy:%g, std:%g, avg nSV:%g\n',mean(ac),std(ac),mean(nSV));

    
