function err=smootherror(labelv,dvalues,A,B)
%smootheed error as object function for svm optimization

labelv=labelv*2-1;%label is now 1 or -1
tp=sigmoid(labelv(labelv==1),dvalues(labelv==1),A,B);
tp=sum(tp);

fp=1-sigmoid(labelv(labelv==-1),dvalues(labelv==-1),A,B);
fp=sum(fp);

N=length(labelv);
Np=sum(labelv==1);
err=(Np-tp+fp)/N;