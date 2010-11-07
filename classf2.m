function errnum=classf2(xTrain,yTrain,xtest,ytest)
ypredict=classify(xtest,xTrain,yTrain,'quadratic');
errnum=sum(ypredict~=ytest);