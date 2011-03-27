function logistregtest(label,feat)
%test logistreg

cvp=cvpartition(label,'kfold',5);
n_data=size(feat,1);
dvalues=zeros(n_data,1);
cmd='-c 1 -g 1';
for i=1:5
    model=svmtrain(label(cvp.training(i)),feat(cvp.training(i),:),cmd);
    [~,~,dvalues(cvp.test(i))]=svmpredict(label(cvp.test(i)),feat(cvp.test(i),:),model);
end
[A,B]=logistreg(label,dvalues);
fprintf('regres result is A=%g, B=%g\n',A,B);