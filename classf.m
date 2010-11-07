function predict=classf(xtrain,labeltrain,xtest)
%return the classification error of classify
predict=classify(xtest,xtrain,labeltrain,'quadratic');

