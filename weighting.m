function weight_idx=weighting(group_idx,train_label,sigma,grp_start,grp_end,MAX_iter,step)
%calculate the weighting of bins

weight_idx=zeros(size(group_idx));
ss=load('train_feature');
train_feature=ss.train_feature;

for grp=grp_start:grp_end
    points=find(group_idx==grp);
    x=group_feature_extract_withinput(size(group_idx),points,train_feature);
    wlda=lda(train_label,x);
    [w,flag]=gradient_descend(train_label,x,wlda',sigma,MAX_iter,step);
    weight_idx(group_idx==grp)=w';
    fprintf('w for group %d = (%f,%f,%f,%f)\n',grp,w(0),w(1),w(2),w(3));
    output(flag);
end

function output(flag)
if flag==0
    fprintf('increase of MI is smaller than tolerant.\n');
elseif flag==1
    fprintf('max magnitude of gradient is smaller than tolerent.\n');
else
    fprintf('max iteration is reached.\n');
end