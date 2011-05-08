function [thetas]=runsvmgrid(label,feat,cvpa,rangec,rangeg)
%a wrapper of grid search for a set of splits

N=length(cvpa);
K=5; %number of cv runed per split
thetas=zeros(N,2);

for i=1:N
    cvp=cvpa(i);
    fprintf('processing %dth split\n',i);
    thetatmp=zeros(K,2);    
    for k=1:K
        [thetatmp(k,:)]=svmgrid(label(cvp.training),feat(cvp.training,:),rangec,rangeg);        
    end
    thetas(i,:)=median(thetatmp);    
    fprintf('best params chose for the split is (%d,%d)\n\n',thetas(i,1),thetas(i,2));
end
