function [w,flag,iter]=groupweight(grp,group_idx,transmat,label,Max_iter,step,Tol,display)
%calculate group weight

if isempty(Max_iter), Max_iter=1000; end
if isempty(step), step=1;end
if isempty(Tol), Tol=1e-5;end
if isempty(display),display=0;end

x=group_feature_extract(find(group_idx==grp),transmat);
[w,flag,iter]=gradient_descend(label,x,Max_iter,step,display,Tol);