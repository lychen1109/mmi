function weight_idx=ldaweighting(group_idx,label,transmat)
%weight groups with LDA

weight_idx=zeros(size(group_idx));
MAXGROUP=max(group_idx(:));
for grp=1:MAXGROUP
    if isempty(find(group_idx==grp,1))
        continue
    end
    x=group_feature_extract(find(group_idx==grp),transmat);
    if size(x,2)>1
        w=lda(label,x);
    else
        w=1;
    end
    weight_idx(group_idx==grp)=w;
end
