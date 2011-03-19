function cvparray=dataspliter(N,label,n_test)
%randomly generate split sets

cvparray=repmat(cvpartition(label,'holdout',n_test),N,1);
for i=2:N
    cvparray(i)=cvpartition(label,'holdout',n_test);
end
    