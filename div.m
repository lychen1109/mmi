function d=div(p,q)
%KL divergence between to probability matrix
%q is theoretical value. Make sure it doesn't have zero.

[N,M]=size(p);
np=p;
nq=q;
d=0;
for i=1:N    
    if sum(np(i,:))>0
        np(i,:)=np(i,:)/sum(np(i,:));
    end
    if sum(nq(i,:))>0
        nq(i,:)=nq(i,:)/sum(nq(i,:));
    end
end

for i=1:N
    for j=1:M
        if p(i,j)>0
            d=d+p(i,j)*log(np(i,j)/nq(i,j));
        end
    end
end



