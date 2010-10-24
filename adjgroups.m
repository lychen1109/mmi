function agroups=adjgroups(grp,group_idx)
%look for adjacent groups

THISGROUP=-5;
ADJGROUP=-10;
T=13;
grouppoints=find(group_idx==grp);
group_idx(group_idx==grp)=THISGROUP;
agroups=[];
for i=1:length(grouppoints)
    [sx,sy]=ind2sub(size(group_idx),grouppoints(i));
    for k=-1:1
        for l=-1:1
            if sx+k>0 && sx+k<=2*T+1 && sy+l>0 && sy+l<=2*T+1
                if group_idx(sx+k,sy+l)>0
                    candidate=group_idx(sx+k,sy+l);
                    agroups=[agroups;candidate];
                    group_idx(group_idx==candidate)=ADJGROUP;
                end
            end
        end
    end
end

