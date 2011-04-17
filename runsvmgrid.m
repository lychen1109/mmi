function thetas=runsvmgrid(label,feat,cvpa,rangec,rangeg)
%a wrapper of grid search for a set of splits

N=length(cvpa);
thetas=zeros(N,2);

for i=1:N
    cvp=cvpa(i);
    fprintf('processing %dth split\n',i);
    [thetas(i,1),thetas(i,2)]=svmgrid(label(cvp.training),feat(cvp.training,:),rangec,rangeg);
end
