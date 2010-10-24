function dist=group2group(candidategroup,group,group_idx)
%calculate distance between two groups
dist=0;
candidates=find(group_idx==candidategroup);
for i=1:length(candidates)
    dist=max(dist,bin2group(candidates(i),group,group_idx));
end
