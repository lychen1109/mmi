function delta=svmoutputgrad(labelv,outputv,A,B)
%SVM likelihood gradient with output function

outputvp=outputv(labelv==1);
outputvn=outputv(labelv==0);
N=length(labelv);
delta=zeros(N,1);%gradient of objective function with output
delta(labelv==1)=-A*exp(A.*outputvp+B)./(1+exp(A.*outputvp+B));
delta(labelv==0)=A*exp(-A.*outputvn-B)./(1+exp(-A*outputvn-B));