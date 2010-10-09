function c_set=candidate_set(group_idx,f_idx,dist_MAX)
% create candidate sets. f_idx is current feature index. dist_MAX is the
% max distance allowed in the feature group.

current_features=find(group_idx==f_idx);

if isempty(current_features)
    c_set=find(group_idx==0);
    return;
end

c_set=[];
c_idx=0;
B=size(group_idx,1);%boundary of point index

for i=1:length(current_features)
    [sx,sy]=ind2sub(size(group_idx),current_features(i));    
    for k=-1:1
        for l=-1:1
            if sx+k>0 && sx+k<B && sy+l>0 && sy+1<B && group_idx(sx+k,sy+l)==0 && max_dist(size(group_idx),current_features,[sx+k,sy+l])<dist_MAX
               %fprintf('(%d,%d) is added\n',sx+k,sy+l);
               c_idx=c_idx+1;
               c_set(c_idx,:)=[current_features' sub2ind(size(group_idx),sx+k,sy+l)];
               group_idx(sx+k,sy+l)=999;%mark the point not to be considered again, it won't update group_idx outside of the function            
            end            
        end
    end    
end


function m=max_dist(group_size,current_features,candidate)
% max distance between the candidate and current_features
m=0;
cx=candidate(1);
cy=candidate(2);
for i=1:length(current_features)
    [fx,fy]=ind2sub(group_size,current_features(i));
    dist=norm([cx,cy]-[fx,fy]);
    if dist>m
        m=dist;
    end
end
