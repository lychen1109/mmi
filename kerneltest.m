function [accu_training,accu_test]=kerneltest(label,data,cvp,kernel,cmd)
%test one kernel's training and test accuracy

labeltrain=label(cvp.training);
datatrain=data(cvp.training,:);
labeltest=label(cvp.test);
datatest=data(cvp.test,:);
n_train=size(datatrain,1);
n_test=size(datatest,1);

model=svmtrain(labeltrain,[(1:n_train)' datatrain*kernel*datatrain'],cmd);
predict_train=svmpredict(labeltrain, [(1:n_train)' datatrain*kernel*datatrain'], model);
accu_training=sum(predict_train==labeltrain)/n_train;

predict_test=svmpredict(labeltest,[(1:n_test)' datatest*kernel*datatrain'],model);
accu_test=sum(predict_test==labeltest)/n_test;