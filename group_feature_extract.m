function features=group_feature_extract(points,transmat)
%extract feature to be transformed

samplesize=size(transmat,3);
pointnum=length(points);
features=zeros(samplesize,pointnum);
T=13;

for i=1:pointnum
   [sx,sy]=ind2sub([2*T+1 2*T+1],points(i));
   f=transmat(sx,sy,:);
   features(:,i)=f(:);
end
