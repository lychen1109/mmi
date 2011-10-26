function gmmpdftest(gm,feat)
%test performance of gmm pdf calc
tic;
p1=pdf(gm,feat);
toc;
disp(p1);
mu=gm.mu;
Sigma=gm.Sigma;
S=gm.PComponents;
tic;
p2=gmmpdf(mu,Sigma,S,feat);
toc;
disp(p2);

