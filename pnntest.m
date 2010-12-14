function [m,s]=pnntest(feat,label,spread,k,n_test)
% random test of probability network

result=zeros(k,1);
for i=1:k
    traincvp=cvpartition(label,'holdout',n_test);
    T=ind2vec(label(traincvp.training)'+1);
    net=newpnn(feat(traincvp.training,:)',T,spread);
    A=sim(net,feat(traincvp.test,:)');
    Ac=vec2ind(A)-1;
    result(i)=sum(Ac'==label(traincvp.test))/n_test;
    disp(result(i));
end
m=mean(result);
s=std(result);