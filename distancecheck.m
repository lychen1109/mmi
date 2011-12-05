function distmat=distancecheck(aufeat,spfeat)
%check distance between authentic images and spliced images

nau=size(aufeat,1);
nsp=size(spfeat,1);
distmat=zeros(nsp,nau);
for i=1:nsp
    for j=1:nau
        distmat(i,j)=norm(spfeat(i,:)-aufeat(j,:));
    end
end
