function d=div2(p,q)
%just like div, but without row normalization

[N,M]=size(p);
d=0;
for i=1:N
    for j=1:M
        if p(i,j)>0
            d=d+p(i,j)*log(p(i,j)/q(i,j));
        end
    end
end
