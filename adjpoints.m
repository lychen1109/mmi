function points=adjpoints(currentpoints,group_idx)
%return the adjacent points of the input ones

adjgroup=-10;%used to temperary identify selected points
thisgroup=-5;
group_idx(currentpoints)=thisgroup;
T=13;

for i=1:length(currentpoints)
   [sx,sy]=ind2sub(size(group_idx),currentpoints(i));
   for k=-1:1
       for l=-1:1
           if sx+k>0 && sx+k<=2*T+1 && sy+l>0 && sy+l<=2*T+1 %not outside of the bound
               if group_idx(sx+k,sy+l)>=0 %can be selected and not selected
                   group_idx(sx+k,sy+l)=adjgroup;%mark as selected for output
               end
           end
       end
   end
end

points=find(group_idx==adjgroup);