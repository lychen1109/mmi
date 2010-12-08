function f=markovfeat(transmat)
% extract feature with original markov feature

n_sample=size(transmat,3);
range=size(transmat,1);

for i=1:n_sample
    tm=transmat(:,:,i);
    for j=1:range
        if sum(tm(j,:))>0
            tm(j,:)=tm(j,:)/sum(tm(j,:));
        end
    end
    transmat(:,:,i)=tm;
end

f=reshape(transmat,range^2,n_sample)';

