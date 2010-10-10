function visualize_groups(color_idx,map,B)
%draw group points. B is the boundary 256-B:256+B

origin=[256,256];

color_idx=color_idx(origin(1)-B:origin(1)+B,origin(2)-B:origin(2)+B);
color_idx(end+1,:)=0;
color_idx(:,end+1)=0;

pcolor(color_idx);
colormap(map)
axis ij
axis square




