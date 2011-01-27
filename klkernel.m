function K=klkernel(set1,set2,g,type)
%return training and test kernel matrix

n1=size(set1,1);
n2=size(set2,1);
K=zeros(n1,n2);
for i=1:n1
    for j=1:n2
        kld=kl_div(set1(i,:),set2(j,:),type);
        K(i,j)=exp(-g*kld);
    end
end

