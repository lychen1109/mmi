function theta=paramlearn(labeltrain,datatrain)
%paramlearn: learn the best parameter of standard gauss kernel and
%probability params

validationcvp=cvpartition(labeltrain,'holdout',400);
theta=[0 0 -1 0]; %initial value
cmd=['-c ' num2str(2^theta(1)) ' -g ' num2str(2^theta(2))];
model=svmtrain(labeltrain(validationcvp.training),datatrain(validationcvp.training,:),cmd);
[~,~,dvalues]=svmpredict(labeltrain(validationcvp.test),datatrain(validationcvp.test,:),model);
grad=paramgrad(labeltrain(validationcvp.test),datatrain(validationcvp.test,:),dvalues,model,theta);
disp('grad is');
disp(grad);