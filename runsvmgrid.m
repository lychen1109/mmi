function [thetas,bestcv,cvmat,nsvmat,bsvmat]=runsvmgrid(label,feat,cvpa,rangec,rangeg)
%a wrapper of grid search for a set of splits

N=length(cvpa);
thetas=cell(N,1);
bestcv=zeros(N,1);
cvmat=cell(N,1);
nsvmat=cell(N,1);
bsvmat=cell(N,1);

for i=1:N
    cvp=cvpa(i);
    fprintf('processing %dth split\n',i);
    [thetas{i},bestcv(i),cvmat{i},nsvmat{i},bsvmat{i}]=svmgrid(label(cvp.training),feat(cvp.training,:),rangec,rangeg);
end
