function gmmpdftest(gm,feat)
%test performance of gmm pdf calc
tic;
pdf(gm,feat);
toc;
tic;
mu=gm.mu;
Sigma=gm.Sigma;
S=gm.PComponents;
K=length(S);
p=0;
toc;
tic;
for i=1:K
    p=p+S(i)*gausspdf(mu(i,:),Sigma(:,:,i),feat);
end
toc;

