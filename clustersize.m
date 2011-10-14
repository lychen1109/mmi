function clustersize(idx)
%printf cluster size of cluster index

K=max(idx);
for i=1:K
    ni=sum(idx==i);
    fprintf('cluster %d: %d\n',i,ni);
end
