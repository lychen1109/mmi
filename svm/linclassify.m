function accu=linclassify(labeltrain,datatrain,labeltest,datatest,type)
%linear classifier

predict=classify(datatest,datatrain,labeltrain,type);
numtest=length(labeltest);
accu=sum(predict==labeltest)/numtest;