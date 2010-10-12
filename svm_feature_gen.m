function f=svm_feature_gen(autrain,group_idx,weight_idx)
% from images to svm ready features
% autrain: every image in a row.
% f: every feature in a row.

GRPNUM=max(group_idx(:));

transmat=extract_feature(autrain,1);
f=zeros(size(transmat,3),GRPNUM);
for grp=1:GRPNUM
    bins=find(group_idx==grp);
    x=group_feature_extract_withinput(size(group_idx),bins,transmat);
    w=weight_idx(bins)';
    f(:,grp)=x*w';
end