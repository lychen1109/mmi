function p=gmmpdf(gm,X)
%gmm pdf calc

mu=gm.mu;
Sigma=gm.Sigma;
S=gm.PComponents;
K=length(S);
p=0;
for i=1:K
    p=p+S(i)*gausspdf(mu(i,:),Sigma(:,:,i),X);
end




