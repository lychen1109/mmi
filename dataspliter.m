function cvparray=dataspliter(N,label,n_test)
%randomly generate split sets

cvparray=zeros(N,1);
for i=1:N
    cvparray(i)=cvpartition(label,'holdout',n_test);
end
    