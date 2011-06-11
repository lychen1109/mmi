function f=corrfeat(transmat)
%extract correlation feature from co-occurence matrix

N=size(transmat,3);
f=zeros(N,1);
for i=1:N
    for j=-4:4
        for k=-4:4
            f(i)=f(i)+j*k*transmat(j+5,k+5,i);
        end
    end
end
