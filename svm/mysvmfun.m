function [modelstruct,accu,dvalues]=mysvmfun(labeltrain,datatrain,labeltest,datatest,theta)
%this is a standard RBF kernel test function
%C=theta(1), g=theta(2)

C=2^theta(1);
cmd=['-c ' num2str(C) ' -g ' num2str(2^theta(2))];
model=svmtrain(labeltrain,datatrain,cmd);
[~,accu,dvalues]=svmpredict(labeltest,datatest,model);
modelstruct=modelparse(model,C);

