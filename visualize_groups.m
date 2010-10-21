function visualize_groups(color_idx,map)
%draw group points. 

color_idx(end+1,:)=0;
color_idx(:,end+1)=0;

pcolor(color_idx);
colormap(map)
axis ij
axis square




