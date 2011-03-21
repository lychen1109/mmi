function [thetaarray,historyarray]=singlegammalearn(label,data,cvpa,theta)
%learn params for a set of spliters

N=length(cvpa);
thetaarray=zeros(N,length(theta));%every row is learned theta for one split
history.thetas=[];
history.ofuns=[];
historyarray(1:N)=history;

for i=1:N
    fprintf('learning %dth split\n',i);
    cvp=cvpa(i);    
    [thetaarray(i,:),historyarray(i)]=paramlearn(label(cvp.training),data(cvp.training,:),theta,@mysvmfun,@paramgrad);
    I=size(historyarray(i).ofuns,1);    
    fprintf('params of %dth split learned in %d iters\n',i,I);
end
