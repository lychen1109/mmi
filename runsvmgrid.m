function [thetas,bestcv]=runsvmgrid(label,feat,cvpa,rangec,rangeg)
%a wrapper of grid search for a set of splits

N=length(cvpa);
thetas=zeros(N,2);
bestcv=zeros(N,1);

for i=1:N
    cvp=cvpa(i);
    fprintf('processing %dth split\n',i);
    [thetas(i,:),bestcv(i)]=svmgrid(label(cvp.training),feat(cvp.training,:),rangec,rangeg);
    fprintf('bestcv is %g\n',bestcv(i));
end
