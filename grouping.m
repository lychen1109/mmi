function group_idx=grouping(group_idx,train_label,grp_start,grp_end,dist_max)
% create the grouping, start from grp_start, end at grp_end, point in the
% group must not farther than dist_max

%check if grp_start has already exist
if ~isempty(find(group_idx==grp_start, 1))
    fprintf('The group already exist.\n');
    return;
end

DEBUG=1;
sigma=0.05;

for grp=grp_start:grp_end
    c_set=candidate_set(group_idx,grp,dist_max);
    if DEBUG
        fprintf('candidate size is %d.\n',size(c_set,1));
    end
    while ~isempty(c_set)
        if size(c_set,2)>1
            candidatesize=size(c_set,1);
            c_mi=zeros(candidatesize,1);
            for i=1:candidatesize
                features=group_feature_extract(size(group_idx),c_set(i,:));
                c_mi(i)=mymi2(train_label,features,sigma);
            end
        else
            ss=load('bin_mi.mat','bin_mi');
            bin_mi=ss.bin_mi;
            c_mi=bin_mi(c_set);
        end
        
        [~,maxidx]=max(c_mi);
        max_candidate_point=c_set(maxidx,end);
        group_idx(max_candidate_point)=grp;
        c_set=candidate_set(group_idx,grp,dist_max);
        if DEBUG
            fprintf('candidate size is %d.\n',size(c_set,1));
        end
    end
    if DEBUG
       fprintf('group %d size is %d.\n',grp,length(find(group_idx==grp))); 
    end
end