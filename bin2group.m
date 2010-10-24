function dist=bin2group(bin,group,group_idx)
%bin to group distance
dist=0;
points=find(group_idx==group);
[m,n]=size(bin);
if m==1 && n==1
    [x0,y0]=ind2sub(size(group_idx),bin);
elseif m==1 && n==2
    x0=bin(1);
    y0=bin(2);
else
    fprintf('bin should be either an integer or 1x2 matrix.\n');
    return
end
    
for i=1:length(points)
    [sx,sy]=ind2sub(size(group_idx),points(i));
    dist=max(dist,norm([sx-x0,sy-y0]));
end