function ranges=grouptransformrange(group_idx,weight_idx,transmat)
%check range of group feature in transformed space

maxgroup=max(group_idx(:));
ranges=zeros(maxgroup,2);
for i=1:maxgroup
    if isempty(find(group_idx==i,1))
        continue
    end
    grouppoints=find(group_idx==i);
    x=group_feature_extract(grouppoints,transmat);
    y=x*weight_idx(grouppoints);
    ranges(i,:)=[max(y) min(y)];
end

    