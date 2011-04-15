function [thetas,fvals,exitflags,outputs,histories]=runparamlearngroup(label,data,cvpa,thetaa_init,group)
%batch learn of group params

N=length(cvpa);
n_theta=size(thetaa_init,2);
thetas=zeros(N,n_theta);
fvals=zeros(N,1);
exitflags=zeros(N,1);
outputs=cell(N,1);
histories=cell(N,1);

for i=1:N
    fprintf('learning %dth split\n',i);
    cvp=cvpa(i);
    [thetas(i,:),fvals(i),exitflags(i),outputs{i},histories{i}]=paramlearngroup(label(cvp.training),data(cvp.training,:),...
                                                    label(cvp.test),data(cvp.test,:),thetaa_init(i,:),group);    
end
