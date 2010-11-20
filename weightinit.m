function weight_idx=weightinit(history)
%initialize weight_idx

cv=history.cv;
[~,I]=max(cv);
%disp(I);
feat=history.feat(I,:);
%disp(sum(feat));

n_feat=size(feat,2);
n_group=sum(feat);
weight_idx=zeros(n_group,n_feat);
Y=find(feat);
X=1:n_group;
idx=sub2ind(size(weight_idx),X,Y);
weight_idx(idx)=1;


