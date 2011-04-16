function thetaa=svmgridsets(label,feat,cvpa)
%a wrapper of grid search for a set of splits

N=length(cvpa);
thetaa=zeros(N,2);
rangec=-2:8;
rangeg=-7:7;

for i=1:N
    cvp=cvpa(i);
    [thetaa(i,1),thetaa(i,2)]=svmgrid(label(cvp.training),feat(cvp.training,:),rangec,rangeg);
end
