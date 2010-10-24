function [weight_idx,record]=weighting(group_idx,label,transmat,MAX_iter,step,Tol,display)
%calculate the weighting of bins

if isempty(MAX_iter), MAX_iter=1000; end
if isempty(step),step=1; end
if isempty(Tol), Tol=1e-5; end
if isempty(display),display=0;end

weight_idx=zeros(size(group_idx));
MAXGROUP=max(group_idx(:));
record=zeros(MAXGROUP,2);

for grp=1:MAXGROUP
    if isempty(find(group_idx==grp,1))
        continue;
    end
    x=group_feature_extract(find(group_idx==grp),transmat);
    if size(x,2)>1            
        [w,flag,iter]=gradient_descend(label,x,MAX_iter,step,display,Tol);
        fprintf('w for group %d reached after %d iters with flag %d\n',grp,iter,flag);
        record(grp,:)=[iter flag];
    else
        w=1;
    end    
    weight_idx(group_idx==grp)=w';        
end

