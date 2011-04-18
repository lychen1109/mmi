function thetas=runsvmgrid3(label,feat,cvpa,group,rangec,rangeg1,rangeg2)
%a wrapper of grid search for a set of splits

N=length(cvpa);
thetas=zeros(N,3);

for i=1:N
    cvp=cvpa(i);
    fprintf('processing %dth split\n',i);
    [thetas(i,1),thetas(i,2),thetas(i,3)]=svmgrid3(label(cvp.training),feat(cvp.training,:),group,rangec,rangeg1,rangeg2);
end
