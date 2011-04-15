function [thetas,fvals,exitflags,outputs,histories]=runparamlearn(label,data,cvpa,theta)
%learn params for a set of spliters

N=length(cvpa);
thetas=zeros(N,length(theta));%every row is learned theta for one split
fvals=zeros(N,1);
exitflags=zeros(N,1);
outputs=cell(N,1);
histories=cell(N,1);

for i=1:N
    fprintf('learning %dth split\n',i);
    cvp=cvpa(i);    
    [thetas(i,:),fvals(i),exitflags(i),outputs{i},histories{i}]=paramlearn(label(cvp.training),data(cvp.training,:),...
                                                                label(cvp.test),data(cvp.test,:),theta);    
end
