function K=rbfkernel(data1,data2,gamma)
%calculate rbf kernel matrix exp(-gamma*|u-v|^2)

n1=size(data1,1);
n2=size(data2,1);
K=zeros(n1,n2);
for i=1:n1
    for j=1:n2
        K(i,j)=exp(-gamma*norm(data1(i,:)-data2(j,:))^2);
    end
end
