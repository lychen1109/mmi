function gmmpdf(gm,X)
%test gmm pdf calc

fprintf('calculate with pdf function: %g\n',pdf(gm,X));

mu=gm.mu;
Sigma=gm.Sigma;
S=gm.PComponents;
p=S(1)*gausspdf(mu(1,:),Sigma(:,:,1),X)+S(2)*gausspdf(mu(2,:),Sigma(:,:,2),X);
fprintf('manully calculated pdf: %g\n',p);


