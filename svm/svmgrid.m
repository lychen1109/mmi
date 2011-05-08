function [theta,bestcv]=svmgrid(grpTrain,dataTrain,rangec,rangeg)
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
    [cvmat(i) nsvmat(i) bsvmat(i)]=mysvmcv(grpTrain,dataTrain,theta(i,:));
end

bestcv=max(cvmat(:));
selection=find(cvmat==bestcv);
if length(selection)>1
    fprintf('multiple CVs found, choosing the least number of SV\n');
    n_svs=nsvmat(selection);
    b_svs=bsvmat(selection);
    min_n_sv=min(n_svs);
    selection_nsv=find(n_svs==min_n_sv);
    if length(selection_nsv)>1
        fprintf('multiple nSVs found, choosing the least number of bounded SV\n');
        b_svs=b_svs(selection_nsv);
        min_b_sv=min(b_svs);
        selection_bsv=find(b_svs==min_b_sv);
        if length(selection_bsv)>1
            error('can not decide the best cv\n');
        else
            theta=theta(selection(selection_nsv(selection_bsv)),:);
        end
    else
        theta=theta(selection(selection_nsv),:);
    end    
else
    theta=theta(selection,:);
end








