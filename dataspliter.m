function cvparray=dataspliter(N,label,n_test)
%randomly generate split sets

cvparray(1:N)=cvpartition(label,'holdout',n_test);
for i=2:N
    cvparray(i)=cvpartition(label,'holdout',n_test);
end
    