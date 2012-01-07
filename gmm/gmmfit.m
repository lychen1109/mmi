function gm=gmmfit(X,rangek)
%fit pdf of X with the best GMM

AICs=zeros(size(rangek));
opt=statset('display','final','maxiter',1000);
K=length(rangek);
gms=cell(K,1);
for i=1:K
    k=rangek(i);
    gms{i}=gmdistribution.fit(X,k,'replicates',20,'CovType','diagonal','SharedCov',false,'options',opt);
    AICs(i)=gms{i}.AIC;    
end

fprintf('AIC of k=%d is %g\n',[rangek;AICs]);
[~,minAIC]=min(AICs);
fprintf('number of component is %d\n',rangek(minAIC));
gm=gms{minAIC};