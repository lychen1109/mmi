function [thetaa,historya]=rowgammalearn(label,data,cvpa,thetaa_single)
%learn row rbf params based on single gamma result

N=length(cvpa);
thetaa=zeros(N,12);
for i=1:N
    thetaa(i,1)=thetaa_single(i,1);
    thetaa(i,2:10)=thetaa_single(i,2);
    thetaa(i,11:12)=thetaa_single(i,3:4);
end
history.thetas=[];
history.ofuns=[];
historya(1:N)=history;

for i=1:N
    fprintf('learning %dth split\n',i);
    cvp=cvpa(i);
    [thetaa(i,:),historya(i)]=paramlearn(label(cvp.training),data(cvp.training,:),thetaa(i,:),@rowsvmfun,@rowparamgrad);
    I=size(historya(i).ofuns,1);
    fprintf('params of %dth split learned in %d iters\n',i,I);
end
