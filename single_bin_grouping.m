function group_single=single_bin_grouping(bin_mi)
%check the top 49 relevant bin

group_single=zeros(size(bin_mi));
[~,I]=sort(bin_mi(:),1,'descend');
group_single(I(1:49))=1:49;