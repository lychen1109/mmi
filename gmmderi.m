function de=gmmderi(gm,X)
%derivative of log pdf of gmm model

mu=gm.mu;
Sigma=gm.Sigma;
de=zeros(size(X));
S=gm.PComponents;
K=length(X);

for i=1:K
    de(i)=-S(1)*gausspdf(mu(1,:),Sigma(:,:,1),X)*(X(i)-mu(1,i))/Sigma(1,i,1)...
        -S(2)*gausspdf(mu(2,:),Sigma(:,:,2),X)*(X(i)-mu(2,i))/Sigma(1,i,2);
end
de=de/pdf(gm,X);
