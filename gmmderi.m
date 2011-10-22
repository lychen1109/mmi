function de=gmmderi(gm,X)
%derivative of log pdf of gmm model

mu=gm.mu;
Sigma=gm.Sigma;
de=zeros(size(X));
S=gm.PComponents;
K=length(X);
N=length(S);

for i=1:K
    for j=1:N
        de(i)=de(i)-S(j)*gausspdf(mu(j,:),Sigma(:,:,j),X)*(X(i)-mu(j,i))/Sigma(1,i,j);
    end   
end
de=de/pdf(gm,X);
