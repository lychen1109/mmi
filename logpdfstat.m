function logpdf=logpdfstat(gm,feat)
%log-likelihood of samples under the gmm model

N=size(feat,1);
logpdf=zeros(N,1);
for i=1:N
    logpdf(i)=log(pdf(gm,feat(i,:)));
end
