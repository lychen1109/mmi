function [thetaa,fvala,exitflaga,outputc,historys]=rowgammalearn(label,data,cvpa,thetaa_init)
%learn row rbf params based on single gamma result

N=length(cvpa);
n_theta=size(thetaa_init,2);
thetaa=zeros(N,n_theta);
fvala=zeros(N,1);
exitflaga=zeros(N,1);
outputc=cell(N,1);
historys=cell(N,1);

for i=1:N
    fprintf('learning %dth split\n',i);
    cvp=cvpa(i);
    [thetaa(i,:),fvala(i),exitflaga(i),outputc{i},historys{i}]=paramlearnotb2(label(cvp.training),data(cvp.training,:),...
                                                    label(cvp.test),data(cvp.test,:),thetaa_init(i,:),@rowsvmfun,@rowparamgrad,...
                                                    @logistreg,@svmllhood,@svmoutputgrad);    
end
