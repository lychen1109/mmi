function A=normal(A)
%return row normalized version of A

N=size(A,1);
for i=1:N
    if sum(A(i,:))>0
        A(i,:)=A(i,:)/sum(A(i,:));
    end
end
