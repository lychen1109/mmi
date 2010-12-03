function bin_ldaaccu=ldaaccu(label,feat,holdoutCVP)
%calculate lda accuracy of each bin

n_feat=size(feat,2);
bin_ldaaccu=zeros(n_feat,1);

for i=1:n_feat
    datatrain=feat(holdoutCVP.training,i);
    datatest=feat(holdoutCVP.test,i);
    labeltrain=label(holdoutCVP.training);
    labeltest=label(holdoutCVP.test);
    predict=classify(datatest,datatrain,labeltrain,'quadratic');
    n_test=size(labeltest,1);
    bin_ldaaccu(i)=sum(predict==labeltest)/n_test;
end
