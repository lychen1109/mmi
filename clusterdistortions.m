function dk=clusterdistortions(feat,idx,C)
%calculate distortions of samples under the input index and centers

N=size(feat,1);
p=size(feat,2);
dk=0;
for i=1:N
    c=idx(i);
    dk=dk+norm(feat(i,:)-C(c,:))^2;
end
dk=dk/N/p;
