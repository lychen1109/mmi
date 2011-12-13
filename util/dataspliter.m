function cvps=dataspliter(N,label,n_test)
%randomly generate split sets

cvps=cell(N,1);
for i=1:N
    cvps{i}=cvpartition(label,'holdout',n_test);
end
    