function bestidx=mindist(aufeat,spfeat)
%select most similar image pairs with repeated greedy algorithm

nau=size(aufeat,1);
nsp=size(spfeat,1);
K=50;

distmat=zeros(nsp,nau);
for i=1:nsp
    for j=1:nau
        distmat(i,j)=norm(spfeat(i,:)-aufeat(j,:));
    end
end

bestdistsum=inf;
for k=1:K
    fprintf('k=%d\n',k);
    distmati=distmat;
    randidx=randperm(nsp);
    auidx=zeros(nsp,1);
    sumvec=zeros(nsp,1);
    for i=1:nsp
        currentimg=randidx(i);
        [sumvec(currentimg),auidx(currentimg)]=min(distmati(currentimg,:));        
        distmati(:,auidx(currentimg))=inf;
    end
    distsum=sum(sumvec);
    fprintf('distsum=%g\n',distsum);
    if distsum<bestdistsum
        bestdistsum=distsum;
        bestidx=auidx;
    end
end


