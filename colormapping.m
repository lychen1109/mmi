function color_idx=colormapping(group_idx)
%fill in color index

color_idx=zeros(size(group_idx));

% omitted bins are marked as gray
color_idx(group_idx==-1)=0;

% unused bins are marked as white
color_idx(group_idx==0)=1;

MAXGROUP=max(group_idx(:));

for grp=1:MAXGROUP    
    [color_idx,filled]=colorfill(color_idx,grp,group_idx);
    if ~filled
        fprintf('colormapping failed.\n');
        return;
    end    
end

function [color_idx,filled]=colorfill(color_idx,grp,group_idx)
% fill in the colors
% - points should have the same color
% - the color doesn't conflict with nearby colors

MAXCOLOR=6;%more color can be used be extand colormap
STARTCOLOR=2;%color 0 and 1 is reserved
points=find(group_idx==grp);
B=size(group_idx,1);%boundary of group_idx

color=STARTCOLOR;
conflict=false;
filled=false;

while color<MAXCOLOR+1
   for p=1:length(points)
       [sx,sy]=ind2sub(size(group_idx),points(p));
       for k=-1:1
           for l=-1:1
               if sx+k>0 && sx+k<B && sy+l>0 && sy+l<B && group_idx(sx+k,sy+l)>0 && group_idx(sx+k,sy+l) ~=grp && color_idx(sx+k,sy+l)==color
                  conflict=true;
                  break;
               end
           end
           if conflict
              break; 
           end
       end
       if conflict
           break;
       end
   end
   if ~conflict
       color_idx(group_idx==grp)=color;
       filled=true;
       break;
   else
       color=color+1;
       conflict=false;
   end
end



