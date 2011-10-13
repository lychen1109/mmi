function [thetas,bestcv]=runsvmgridl(label,feat,cvpa,rangec)
%a wrapper of grid search for a set of splits

N=5; %only use the first five splits for grid search
thetas=[];
bestcv=[];

for i=1:N
    cvp=cvpa(i);
    fprintf('processing %dth split\n',i);    
    [thetatmp,bestcvtmp]=svmgridl(label(cvp.training),feat(cvp.training,:),rangec);
    L=size(thetatmp,1);
    bestcvtmp=ones(L,1)*bestcvtmp;
    thetas=[thetas; thetatmp];
    bestcv=[bestcv;bestcvtmp];
end
