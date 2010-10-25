function f=svm_feature_gen_markovori(transmat)
% extract feature with original markov feature

T=3;
f=zeros(size(transmat,3),(2*T+1)^2);
idx=0;
for i=-T:T
    for j=-T:T
        tmp=transmat(14+i,14+j,:);
        idx=idx+1;
        f(:,idx)=tmp(:);
    end
end