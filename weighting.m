function weight_idx=weighting(group_idx,label,transmat)
%calculate the weighting of bins

MAX_iter=300;
step=1;
weight_idx=zeros(size(group_idx));
MAXGROUP=max(group_idx(:));

for grp=1:1 %MAXGROUP
    if isempty(find(group_idx==grp,1))
        continue;
    end
    x=group_feature_extract(find(group_idx==grp),transmat);
    if size(x,2)>1
        w0=lda(label,x);
        y=x*w0;
        sigma=(max(y)-min(y))/2;    
        [w,flag,iter]=gradient_descend(label,x,w0',sigma,MAX_iter,step);
        fprintf('w for group %d reached after %d iters with flag %d\n',grp,iter,flag);
    else
        w=1;
    end    
    weight_idx(group_idx==grp)=w';        
end

