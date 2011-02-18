function probs=probcalc(dvalues,A,B)
%Calculate probs from dvalues

num=size(dvalues,1);
probs=zeros(num,1);
for i=1:num
    probs(i)=1/(1+exp(A*dvalues(i)+B));
end
