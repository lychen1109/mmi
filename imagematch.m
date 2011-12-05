function finalauidx=imagematch(distmat)
%match every spimage with a cloest authentic image

spidx=zeros(305,10);
spidx(:,1)=(1:305)';
for i=2:10
    randidx=randperm(305);
    spidx(:,i)=randidx';
end
dist=zeros(305,10);
auidx=zeros(size(spidx));
for d=1:10
    [auidx(:,d),dist(:,d)]=matchgen(distmat,spidx(:,d));
    fprintf('sumdist of iter %d is %g\n',d,sum(dist(:,d)));
end

sumdist=sum(dist);
[~,minsum]=min(sumdist);
finalauidx=auidx(:,minsum);

function [returnidx,dist]=matchgen(distmat,pickidx)
returnidx=zeros(305,1);
dist=zeros(305,1);
for i=1:305
    [~,minau]=min(distmat(pickidx(i),:));
    returnidx(pickidx(i))=minau;
    dist(pickidx(i))=distmat(pickidx(i),minau);
    distmat(:,minau)=inf;
end
