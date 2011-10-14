function r=ftest(feat,idx,C)
%calculate ratio of explained variance vs. total variance

N=size(feat,1);
K=size(C,1);
cs=zeros(K,1);

for i=1:K
    cs(i)=sum(idx==i);
end

m=mean(feat);
evar=0;%explained variance

for i=1:K
    evar=evar+cs(i)*norm(C(i,:)-m)^2;
end
%evar=evar/(K-1);

m1=feat-repmat(m,N,1);
var=0;%total variance
for i=1:N
    var=var+norm(m1(i,:))^2;
end
%var=var/(N-1);
r=evar/var;
