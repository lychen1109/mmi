function bound=boundcheck(mat)
%check logic matrix mat's bound

bound=[511 1 1 511];
points=find(mat);
for i=1:length(points)
   [sx,sy]=ind2sub(size(mat),points(i));
   bound=[min(bound(1),sx) max(bound(2),sx) max(bound(3),sy) min(bound(4),sy)];
end