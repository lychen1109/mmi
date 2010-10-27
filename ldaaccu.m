function bin_ldaaccu=ldaaccu(group_idx,label,transmat)
%calculate lda accuracy of each selected bin

bin_ldaaccu=zeros(size(group_idx));
bins=find(group_idx==0);

for i=1:length(bins)
    x=group_feature_extract(bins(i),transmat);
    [~,err]=classify(x,x,label);
    bin_ldaaccu(bins(i))=1-err;
end
