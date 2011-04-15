function L=svmllhood(labelv,outputv,A,B)
%likelihood of svm output

%%%%%%%%%%%%%%%%%%%%%%
% When t is not used
%%%%%%%%%%%%%%%%%%%%%%%
% outputvp=outputv(labelv==1);
% outputvn=outputv(labelv==0);
% Like1=log(1./(1+exp(A*outputvp+B)));
% Like2=log(1-1./(1+exp(A*outputvn+B)));
% L=-sum(Like1)-sum(Like2);

[s,t]=svmlogist(labelv,outputv,A,B);
L=t.*log(s)+(1-t).*log(1-s);
L=-sum(L);