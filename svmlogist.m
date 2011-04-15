function p=svmlogist(labelv,dvalues,A,B)
%svm output regression

labelv=2*labelv-1;
p=1./(1+exp(labelv.*(A*dvalues+B)));
