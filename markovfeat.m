function f=markovfeat(transmat,isnormal)
% extract feature with original markov feature

n_sample=size(transmat,3);
range=size(transmat,1);
if isnormal>0
    for i=1:n_sample
        tm=transmat(:,:,i);
        for j=1:range
            if sum(tm(j,:))>0
                tm(j,:)=tm(j,:)/sum(tm(j,:));
            end
        end
        transmat(:,:,i)=tm;
    end
end
f=reshape(transmat,range^2,n_sample)';
f=svmrescale(f);
