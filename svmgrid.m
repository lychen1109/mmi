function [theta,bestcv,cvmat,nsvmat,bsvmat]=svmgrid(grpTrain,dataTrain,rangec,rangeg)
%parameter selection

nc=length(rangec);
ng=length(rangeg);
cvmat=zeros(nc,ng);
nsvmat=zeros(nc,ng);
bsvmat=zeros(nc,ng);
rangec=rangec(:);
rangeg=rangeg(:);
log2c=repmat(rangec,1,ng);
log2g=repmat(rangeg',nc,1);
theta=[log2c(:) log2g(:)];

parfor i=1:nc*ng    
    [cvmat(i) nsvmat(i) bsvmat(i)]=mysvmcv(grpTrain,dataTrain,theta);
end

bestcv=max(cvmat(:));
theta=theta(cvmat==bestcv,:);







