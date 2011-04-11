function [ distmat ] = crossdist( A,B,group,theta )
%distance calculation of pair instances in vector A and B
%   Detailed explanation goes here

if size(group,2)~=size(A,2)
    error('group index does not have same elements as feature\n');
end

n_group=length(unique(group));
if n_group~=size(theta,2)-1
    error('number of group does not match number of params\n');
end
if n_group ~= max(group)
    error('group id should start from 1 and continues\n');
end

NA=size(A,1);
NB=size(B,1);
distmat=zeros(NA*NB,1);
idx=zeros(NA*NB,size(A,2),2);
for i=1:NA
    idx((i-1)*NB+(1:NB),:,1)=A(i,:);
    idx((i-1)*NB+(1:NB),:,2)=B;
end

parfor i=1:NA*NB
    distmat(i)=sampledist(idx(i,:,:),group,theta);
end

distmat=reshape(distmat,NB,NA)';

function dist=sampledist(samples,group,theta)
%calculate distance between two sample pairs
s1=samples(1,:,1);
s2=samples(1,:,2);
n_group=max(group);
dist=0;
for i=1:n_group
    g=group==i;
    dist=dist+2^theta(i+1)*norm(s1(g)-s2(g))^2;
end


