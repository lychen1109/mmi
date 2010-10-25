function f=fullfeatures(group_idx,transmat)
%full features 507 dimension

points=find(group_idx==0);
f=zeros(size(transmat,3),length(points));
for i=1:length(points)
    [sx,sy]=ind2sub(size(group_idx),points(i));
    tmp=transmat(sx,sy,:);
    f(:,i)=tmp(:);
end
