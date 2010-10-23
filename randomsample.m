function samples=randomsample(n1,n2,num)
%take num of sample pairs from 1:n1 and 1:n2

samples=zeros(num,2);

if num>n1*n2
    fprintf('There is not enough items to sample.\n');
    return;
end

for i=1:num
    l1=myrandint(1,1,1:n1);
    l2=myrandint(1,1,1:n2);
    samples(i,:)=[l1 l2];
end
