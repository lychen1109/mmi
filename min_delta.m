function min_idx=min_delta(delta)
%find the min index of element in delta

[sorted,I]=sort(delta,2,'ascend');
idx=find(sorted,1);
min_idx=I(idx);
