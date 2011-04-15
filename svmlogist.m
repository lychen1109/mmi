function [s,t]=svmlogist(labelv,dvalues,A,B)
%svm output regression

labelv=2*labelv-1;
s=1./(1+exp(labelv.*(A*dvalues+B)));

t=zeros(size(labelv));
np=sum(labelv==1);
nn=sum(labelv==-1);
t(labelv==1)=(np+1)/(np+2);
t(labelv==-1)=(nn+1)/(nn+2);
