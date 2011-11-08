function thetas=runsvmgridk(label,feat,cvpk,rangec,rangeg)
%a wrapper of grid search for a set of splits

N=3; 
thetas=[];

for i=1:N    
    fprintf('processing %dth split\n',i);    
    thetatmp=svmgrid2(label(cvpk.training(i)),feat(cvpk.training(i),:),rangec,rangeg);    
    %thetas=[thetas; thetatmp];
    thetas=cat(1,thetas,thetatmp);
end
