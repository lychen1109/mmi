function p=svmlogist(f,A,B)
%svm output regression

p=1./(1+exp(A*f+B));
