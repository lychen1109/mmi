function weight_idx=weighting(group_idx,label,transmat)
%calculate the weighting of bins

MAX_iter=1000;
step=100;
weight_idx=zeros(size(group_idx));
MAXGROUP=max(group_idx(:));

for grp=1:MAXGROUP
    if isempty(find(group_idx==grp,1))
        continue;
    end
    x=group_feature_extract(find(group_idx==grp),transmat);
    if size(x,2)>1            
        [w,flag,iter]=gradient_descend(label,x,MAX_iter,step,0);
        fprintf('w for group %d reached after %d iters with flag %d\n',grp,iter,flag);
    else
        w=1;
    end    
    weight_idx(group_idx==grp)=w';        
end

