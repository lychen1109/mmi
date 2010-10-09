function visualize_groups(group_idx,map)
%draw group points

origin=[256,256];
points=2*ones(size(group_idx));%set the background as white
points(group_idx==1)=0;
points(group_idx==2)=1;

points=points(origin(1)-20:origin(1)+20,origin(2)-20:origin(2)+20);
points(end+1,:)=0;
points(:,end+1)=0;

pcolor(points);
colormap(map)
axis ij
axis square




