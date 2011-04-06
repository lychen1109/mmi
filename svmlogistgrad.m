function [pa,pb]=svmlogistgrad(labelv,outputv,A,B)
%svm likelihood grad with logistic params

outputvp=outputv(labelv==1);
outputvn=outputv(labelv==0);
LpA1=-outputvp.*exp(A*outputvp+B)./(1+exp(A*outputvp+B)); %gradient of L with A of positive samples
LpA2=outputvn.*exp(-A*outputvn-B)./(1+exp(-A*outputvn-B)); %gradient of L with A of negative samples
LpB1=-exp(A*outputvp+B)./(1+exp(A*outputvp+B));
LpB2=exp(-A*outputvn-B)./(1+exp(-A*outputvn-B));
pa=-sum(LpA1)-sum(LpA2);
pb=-sum(LpB1)-sum(LpB2);