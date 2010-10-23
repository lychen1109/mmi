function samples=fullsample(n1,n2)
%full interation of items in two array

samples=zeros(n1*n2,2);
idx=0;
for i=1:n1
    for j=1:n2
       idx=idx+1;
       samples(idx,:)=[i j];
    end
end