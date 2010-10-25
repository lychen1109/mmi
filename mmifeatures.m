function features=mmifeatures(groupfiltered,transmat,weight_idx)
%extract final features according to mmi weight

maxgroup=max(groupfiltered(:));
groupleft=zeros(1,maxgroup);
groupidx=1:maxgroup;

%filter out nonexist groups
for i=1:maxgroup
    if ~isempty(find(groupfiltered==i,1))
        groupleft(i)=1;
    end
end

groupidx=groupidx(groupleft==1);
features=zeros(size(transmat,3),length(groupidx));
for i=1:length(groupidx)
    grouppoints=find(groupfiltered==groupidx(i));
    x=group_feature_extract(grouppoints,transmat);
    y=x*weight_idx(grouppoints);
    features(:,i)=y;
end

    
    