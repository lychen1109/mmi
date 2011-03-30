function bsvcheck(labeltrain,datatrain)
%check bounded sv identification

cvp=cvpartition(labeltrain,'kfold',5);
for i=1:5
    labeltrain_i=labeltrain(cvp.training(i));
    datatrain_i=datatrain(cvp.training(i),:);
    labeltest_i=labeltrain(cvp.test(i));
    datatest_i=datatrain(cvp.test(i),:);
    featuresdump([labeltrain_i datatrain_i],['bsvcheck_train_' int2str(i)]);
    featuresdump([labeltest_i datatest_i],['bsvcheck_test_' int2str(i)]);
    [modelstruct,~,~]=mysvmfun(labeltrain_i,datatrain_i,labeltest_i,datatest_i,[0 0]);
    fprintf('bounded sv in fold %d is %d\n',i,length(modelstruct.alphac));
end
    