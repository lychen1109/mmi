function mitransformed=groupmical(group_idx,weight_idx,label,transmat)
%calculate all groupmi according to weight_idx

maxgroup=max(group_idx(:));
sigma=0.5;%rescale every feature to 0..1
mitransformed=zeros(maxgroup,1);
for i=1:maxgroup
    if isempty(find(group_idx==i,1))
        mitransformed(i)=-1;
        continue
    end
    points=find(group_idx==i);
    x=group_feature_extract(points,transmat);
    y=x*weight_idx(points);
    y=(y-min(y))/(max(y)-min(y));
    mitransformed(i)=mymi3(label,1,y,sigma,0);
end

    