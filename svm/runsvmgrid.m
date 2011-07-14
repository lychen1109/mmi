function [thetas,bestcv]=runsvmgrid(label,feat,cvpa,rangec,rangeg)
%a wrapper of grid search for a set of splits

N=5; %only use the first five splits for grid search
thetas=[];
bestcv=[];

for i=1:N
    cvp=cvpa(i);
    fprintf('processing %dth split\n',i);    
    [thetatmp,bestcvtmp]=svmgrid2(label(cvp.training),feat(cvp.training,:),rangec,rangeg);
    L=size(thetatmp,1);
    bestcvtmp=ones(L,1)*bestcvtmp;
    thetas=[thetas; thetatmp];
    bestcv=[bestcv;bestcvtmp];
end
