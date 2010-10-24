function mi=groupmi(group_idx,grp,w,label,transmat)
%check group mi under w

x=group_feature_extract(find(group_idx==grp),transmat);
if size(x,2)>1
    y=x*lda(label,x);
    sigma=(max(y)-min(y))/2;
else
    sigma=(max(x)-min(x))/2;
end

mi=mymi3(label,w,x,sigma,0);
