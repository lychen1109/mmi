function delta=svmoutputgraderr(labelv,dvalues,A,B)
%grad of error with SVM output

labelv=labelv*2-1;
N=length(labelv);
sl=sigmoid(labelv,dvalues,A,B);
spa=-labelv.*dvalues.*sl.*(1-sl);
erpa=(-1/N)*sum(spa);

mu=mean(dvalues);
rho=std(dvalues,1);
Apo=(10/N/rho^3)*(dvalues-mu);

delta=(1/N)*A*labelv.*sl.*(1-sl)+erpa*Apo;