function visualize_groups(group_idx,grp)
%draw group points

origin=[256,256];
points=ones(size(group_idx));
points(group_idx==grp)=0;

points=points(origin(1)-20:origin(1)+20,origin(2)-20:origin(2)+20);
points(end+1,:)=0;
points(:,end+1)=0;

pcolor(points);
colormap gray(2)
axis ij
axis square




