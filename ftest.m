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
evar=evar/(K-1);

uevar=0;%unexplained variance
for i=1:K
    fi=feat(idx==i,:);
    for j=1:cs(i)
        uevar=uevar+norm(fi(j,:)-C(i,:))^2;
    end
end
uevar=uevar/(N-K);

r=evar/uevar;
