function [thetas,bestcv]=svmgrid2(grpTrain,dataTrain,rangec,rangeg)
%simplfied way of crossvalidation

nc=length(rangec);
ng=length(rangeg);
cvmat=zeros(nc,ng);
rangec=rangec(:);
rangeg=rangeg(:);
log2c=repmat(rangec,1,ng);
log2g=repmat(rangeg',nc,1);
thetas=[log2c(:) log2g(:)];

parfor i=1:nc*ng
    cmd=cmdgen(thetas(i,:));
    cvmat(i)=svmtrain(grpTrain,dataTrain,cmd);
end

bestcv=max(cvmat(:));
selection=(cvmat==bestcv);
thetas=thetas(selection(:),:);

function cmd=cmdgen(theta)
%generate SVM cmd according to thetas

C=2^theta(1);
g=2^theta(2);
cmd=['-v 5 -c ' num2str(C) ' -g ' num2str(g)];
