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

for i=1:nc*ng
    cmd=['-v 5 -c ' num2str(2^thetas(i,1)) ' -g ' num2str(2^thetas(i,2))];
    cvmat(i)=svmtrain(grpTrain,dataTrain,cmd);
end

bestcv=max(cvmat(:));
selection=(cvmat==bestcv);
thetas=thetas(selection(:),:);
