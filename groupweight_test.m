function groupweight_test(weight_idx,feat_idx,label,data)
%test function of groupweight

n_group=size(weight_idx,2);
for i=1:n_group
    groupweight(i,feat_idx,weight_idx,data,label,1000,1,1e-6,1);
end

