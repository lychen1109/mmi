function [thetaarray,fvala,exitflaga]=singlegammalearn(label,data,cvpa,theta)
%learn params for a set of spliters

N=length(cvpa);
thetaarray=zeros(N,length(theta));%every row is learned theta for one split
fvala=zeros(N,1);
exitflaga=zeros(N,1);

for i=1:N
    fprintf('learning %dth split\n',i);
    cvp=cvpa(i);    
    [thetaarray(i,:),fvala(i),exitflaga(i)]=paramlearnotb2(label(cvp.training),data(cvp.training,:),theta,@mysvmfun,@paramgrad,@logistreg,@svmllhood,@svmoutputgrad);    
end
