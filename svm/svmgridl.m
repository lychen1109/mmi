function [thetas,bestcv]=svmgridl(grpTrain,dataTrain,rangec)
%crossvalidation using linear kernel

nc=length(rangec);
cvmat=zeros(nc,1);
thetas=rangec(:);

parfor i=1:nc
    cmd=cmdgen(thetas(i));
    cvmat(i)=svmtrain(grpTrain,dataTrain,cmd);
end

bestcv=max(cvmat(:));
selection=(cvmat==bestcv);
thetas=thetas(selection);

function cmd=cmdgen(theta)
%generate SVM cmd according to thetas

C=2^theta;
cmd=['-v 5 -c ' num2str(C) ' -t 0'];
