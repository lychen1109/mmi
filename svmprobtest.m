function svmprobtest(label,feat,cvpa)
%test if svm trained with -b provide the same A and B as self calculated

for i=1:10
    cvp=cvpa(i);
    labeltrain=label(cvp.training);
    datatrain=feat(cvp.training,:);
    model=svmtrain(labeltrain,datatrain,'-c 1 -g 1 -b');
    fprintf('calculated with -b option: A=%g, B=%g\n',model.ProbA,model.ProbB);
    
    cvp5fold=cvpartition(labeltrain,'kfold',5);
    dvalues=zeros(size(labeltrain));
    for j=1:5
        [~,~,dvalues(cvp5fold.test(j))]=mysvmfun(labeltrain(cvp5fold.training(j)),datatrain(cvp5fold.training(j),:),labeltrain(cvp5fold.test(j)),datatrain(cvp5fold.test(j),:),[0 0]);
    end
    [A,B]=logistreg(labeltrain,dvalues);
    fprintf('self calculated A=%g, B=%g\n',A,B);
end
