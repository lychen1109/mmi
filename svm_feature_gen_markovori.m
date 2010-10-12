function f=svm_feature_gen_markovori(autrain)
% extract feature with original markov feature

T=uint16(3);
transmat=extract_feature(autrain,1);
f=zeros(size(transmat,3),(2*T+1)^2);

for i=-T:T
    for j=-T:T
        tmp=transmat(256+i,256+j,:);
        f(:,(i-1)*(2*T+1)+j)=tmp(:);
    end
end