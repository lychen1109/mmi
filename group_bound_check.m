function bound=group_bound_check(group_idx)
%check the location farthest bins used

N=256;
S=256;
E=256;
W=256;

MAXGROUP=max(group_idx(:));
for grp=1:MAXGROUP
   points=find(group_idx==grp);
   for i=1:length(points)
       [sx,sy]=ind2sub(size(group_idx),points(i));
       if sx<N
           N=sx;
       elseif sx>S
           S=sx;
       end
       
       if sy<W
           W=sy;
       elseif sy>E
           E=sy;
       end       
   end
end

N=N-256;
S=S-256;
E=E-256;
W=W-256;

bound=[N,S,E,W];
