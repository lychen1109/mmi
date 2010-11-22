function out=randomsample2(label,N)
% output N random sample pairs

n=size(label,1);
out=zeros(N,2);
for i=1:N
    i1=myrandint(1,1,1:n);
    i2=myrandint(1,1,1:n);
    out(i,:)=[i1 i2];    
end
