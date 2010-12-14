function [m,s]=rbftest(label,feat,spread,goal,k,n_test)
%test rbf with randomly selected test set

result=zeros(k,1);
for i=1:k
    traincvp=cvpartition(label,'holdout',n_test);
    T=ind2vec(label(traincvp.training)'+1);
    net=newrb(feat(traincvp.training,:)',T,goal,spread);
    A=sim(net,feat(traincvp.test,:)');
    predict=myvec2label(A);
    result(i)=sum(predict==label(traincvp.test))/n_test;
    disp(result(i));
end
m=mean(result);
s=std(result);

    