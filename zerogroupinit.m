function bin_mi=zerogroupinit(group_idx,autrain,sptrain,label,sigma)
%calculate MI of group 0

bin_mi=zeros(size(group_idx));
points=find(group_idx==0);
NUMPOINTS=length(points);

for i=1:NUMPOINTS
    bin_feature=group_feature_extract(points(i),autrain,sptrain);
    bin_mi(points(i))=mymi3(label,1,bin_feature,sigma);
end