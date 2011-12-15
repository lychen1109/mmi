function dvalues=dvaluegen(label,feat,theta)
%generate dvalues under a model

cvp5=cvpartition(label,'kfold',5);
dvalues=zeros(size(label));
for i=1:5
    [~,~,dvalues(cvp5.test(i))]=mysvmfun(label(cvp5.training(i)),feat(cvp5.training(i),:),label(cvp5.test(i)),feat(cvp5.test(i),:),theta);
end
