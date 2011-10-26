function p=gmmpdf(mu,Sigma,S,X)
%gmm pdf calc

K=length(S);
p=0;
for i=1:K
    p=p+S(i)*gausspdf(mu(i,:),Sigma(:,:,i),X);
end




