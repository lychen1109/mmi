function dvalue=imgmodeltest(simg,model,range)
%test the effect of modification under the provided SVM model

bdctimg=blkproc(simg,[8 8],@dct2);
bdctimg=abs(round(bdctimg));
T=3;
tm1=tpm1(bdctimg,T);
[~,~,dvalue]=svmpredict(0,svmrescale(tm1(:)',range),model);



