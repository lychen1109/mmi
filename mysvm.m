function errnum=mysvm(dataTrain,grpTrain,dataTest,grpTest)
%wrapper of svmtrain and svmpredict, return number of classification error

[c,g]=svmgrid(dataTrain,grpTrain);
cmd=['-c ' num2str(c) ' -g ' num2str(g)];
model=svmtrain(grpTrain,dataTrain,cmd);
grpPred=svmpredict(grpTest,dataTest,model);
errnum=sum(grpPred~=grpTest);
