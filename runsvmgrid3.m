function [thetas,bestcv,cvmats,nsvmats,bsvmats]=runsvmgrid3(label,feat,cvpa,group,rangec,rangeg1,rangeg2)
%a wrapper of grid search for a set of splits

N=length(cvpa);
thetas=cell(N,1);
bestcv=zeros(N,1);
cvmats=cell(N,1);
nsvmats=cell(N,1);
bsvmats=cell(N,1);

for i=1:N
    cvp=cvpa(i);
    fprintf('processing %dth split\n',i);
    [thetas{i},bestcv(i),cvmats{1},nsvmats{1},bsvmats{1}]=svmgrid3(label(cvp.training),feat(cvp.training,:),group,rangec,rangeg1,rangeg2);
end
