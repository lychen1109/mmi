function color_idx=colormapping(group_idx)
%fill in color index

color_idx=zeros(size(group_idx));

% omitted bins are marked as white
color_idx(group_idx==-1)=0;

MAXGROUP=max(group_idx(:));

for grp=1:MAXGROUP    
    if ~isempty(find(group_idx==grp,1))
        [color_idx,filled]=colorfill(color_idx,grp,group_idx);
        if ~filled
            fprintf('colormapping failed.\n');
            return;
        end
    end
end

function [color_idx,filled]=colorfill(color_idx,grp,group_idx)
% fill in the colors
% - points should have the same color
% - the color doesn't conflict with nearby colors

MAXCOLOR=6;
STARTCOLOR=1;%color 0 is reserved

colorbag=STARTCOLOR:MAXCOLOR;
filled=false;

while ~isempty(colorbag)
   randidx=myrandint(1,1,length(colorbag));
   color=colorbag(randidx);   
   if ~isconflict(group_idx,color_idx,grp,color)
       color_idx(group_idx==grp)=color;
       filled=true;
       return;
   else
       colorbag(randidx)=[];       
   end
end

function c=isconflict(group_idx,color_idx,grp,color)
%check weather it's ok to use this color
points=find(group_idx==grp);
T=13;
for i=1:length(points)
    [sx,sy]=ind2sub(size(group_idx),points(i));
    for k=-1:1
        for l=-1:1
            if sx+k>0 && sx+k<=2*T+1 && sy+l>0 && sy+l<=2*T+1 %the point is within bound
                if group_idx(sx+k,sy+l)~=grp && color_idx(sx+k,sy+l)==color
                    c=true;
                    return;
                end
            end
        end
    end
end
c=false;
    


