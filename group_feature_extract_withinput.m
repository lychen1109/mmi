function features=group_feature_extract_withinput(groupsize,candidate_group,train_feature)
%extract feature to be transformed
%same as group_feature_extract, but take train_feature as input

samplesize=size(train_feature,3);
pointnum=length(candidate_group);
features=zeros(samplesize,pointnum);
for i=1:pointnum
   [sx,sy]=ind2sub(groupsize,candidate_group(i));
   tmp=train_feature(sx,sy,:);
   features(:,i)=tmp(:);
end