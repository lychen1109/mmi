function gmmpdf(gm,X)
%test gmm pdf calc

fprintf('calculate with pdf function: %g\n',pdf(gm,X));

mu=gm.mu;
Sigma=gm.Sigma;
S=gm.PComponents;
p=S(1)*gausspdf(mu(1,:),Sigma(:,:,1),X)+S(2)*gausspdf(mu(2,:),Sigma(:,:,2),X);
fprintf('manully calculated pdf: %g\n',p);


function p=gausspdf(mu,Sigma,X)
%pdf of X in single gauss component

tmp1=0;
tmp2=1;
K=length(mu);

for i=1:K
    tmp1=tmp1+((X(i)-mu(i))^2)/Sigma(i);
    tmp2=tmp2*Sigma(i);
end
p=exp(-0.5*tmp1)/((2*pi)^(K/2))/sqrt(tmp2);