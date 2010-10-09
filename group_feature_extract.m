function features=group_feature_extract(groupsize,candidate_group)
%extract feature to be transformed

ss=load('train_feature.mat','train_feature');
train_feature=ss.train_feature;
samplesize=size(train_feature,3);
pointnum=length(candidate_group);
features=zeros(samplesize,pointnum);
for i=1:pointnum
   [sx,sy]=ind2sub(groupsize,candidate_group(i));
   tmp=train_feature(sx,sy,:);
   features(:,i)=tmp(:);
end