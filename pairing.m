function [ret]=pairing(logpdfori,logpdfnew,pdfsample)
%assign target to proper images

[~,cpidx]=sort(logpdfori,1,'descend');
[sortedpdfsample]=sort(pdfsample,1,'descend');
sortedpdfsample=exchange(sortedpdfsample,2,20);
sortedpdfsample=exchange(sortedpdfsample,7,26);
sortedpdfsample=exchange(sortedpdfsample,8,32);
sortedpdfsample=exchange(sortedpdfsample,9,59);
sortedpdfsample=exchange(sortedpdfsample,19,65);
ret=[cpidx logpdfori(cpidx) logpdfnew(cpidx) sortedpdfsample];

function sortedpdfsample=exchange(sortedpdfsample,i,j)
temp=sortedpdfsample(i);
sortedpdfsample(i)=sortedpdfsample(j);
sortedpdfsample(j)=temp;

