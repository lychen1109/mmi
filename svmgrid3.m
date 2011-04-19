function [thetas,bestcv,cvmat,nsvmat,bsvmat]=svmgrid3(label,feat,group,rangec,rangeg1,rangeg2)
%svmgrid3 does grid search with three hyper-parameters

%turn ranges into column vectors
rangec=rangec(:);
rangeg1=rangeg1(:);
rangeg2=rangeg2(:);

NC=length(rangec);
NG1=length(rangeg1);
NG2=length(rangeg2);

cvmat=zeros(NG1,NG2,NC);
nsvmat=zeros(NG1,NG2,NC);
bsvmat=zeros(NG1,NG2,NC);

log2c(1,1,1:NC)=rangec;
log2c=repmat(log2c,NG1,NG2);
log2g1=repmat(rangeg1,[1,NG2,NC]);
log2g2=repmat(rangeg2',[NG1,1,NC]);
thetas=[log2c(:) log2g1(:) log2g2(:)];

parfor i=1:NC*NG1*NG2    
    [cvmat(i),nsvmat(i),bsvmat(i)]=groupsvmcv(label,feat,group,thetas(i,:));
end

bestcv=max(cvmat(:));
thetas=thetas(cvmat==bestcv,:);