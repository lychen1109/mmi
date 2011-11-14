function [model]=svmmodel(label,images,range)
%generate best svm model as likelihood function

N=size(images,1);
tm=transmatgen(images,3);
feat=reshape(tm,49,N)';
feat=svmrescale(feat,range);
cvpk=cvpartition(label,'kfold',5);
thetas=runsvmgridk(label,feat,cvpk,0:2:10,-6:2:6);
theta=median(thetas);
cmd=['-c ' num2str(2^theta(1)) ' -g ' num2str(2^theta(2))];
model=svmtrain(label,feat,cmd);

