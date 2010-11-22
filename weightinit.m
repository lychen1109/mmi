function [weight_idx,feat]=weightinit(history,N)
%initialize weight_idx

feat=history.feat(end-N+2,:);

n_feat=size(feat,2);
n_group=sum(feat);
weight_idx=zeros(n_group,n_feat);
Y=find(feat);
X=1:n_group;
idx=sub2ind(size(weight_idx),X,Y);
weight_idx(idx)=1;
weight_idx=weight_idx';


