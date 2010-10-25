function group_idx=groupfilter(group_idx,mitransformed,threshold)
%filtering group with mi threshold

maxgroup=size(mitransformed,1);
for i=1:maxgroup
    if mitransformed(i)>=0 && mitransformed(i) <= threshold
        group_idx(group_idx==i)=-2;
    end
end
