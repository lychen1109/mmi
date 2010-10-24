function [mi,milda]=groupmi(group_idx,grp,w,label,transmat)
%check group mi under w

x=group_feature_extract(find(group_idx==grp),transmat);
if size(x,2)>1
    wlda=lda(label,x)';
    y=x*wlda';
    sigma=(max(y)-min(y))/2;
else
    sigma=(max(x)-min(x))/2;
end

mi=mymi3(label,w,x,sigma,0);

if nargout>1
    if size(x,2)>1
        milda=mymi3(label,wlda,x,sigma,0);
    else
        milda=[];
    end
end
