function delta_W2=RFE_evaluate(model)
%evaluate delta W2 according to removal of every single feature

totalSV=model.totalSV;
coef=model.sv_coef;
SVs=model.SVs;
n_feat=size(SVs,2);
g=model.Parameters(4);
idxmat=zeros(totalSV^2,2);
idx=0;
delta_W2=zeros(1,n_feat);
for i=1:totalSV
    for j=1:totalSV
        idx=idx+1;
        idxmat(idx,:)=[i j];
    end
end

W2=0;
for i=1:totalSV^2
    param=idxmat(i,:);
    k=param(1);
    l=param(2);
    W2=W2+coef(k)*coef(l)*gkernel(SVs(k,:),SVs(l,:),g);
end

for i=1:n_feat
    SVs_sub=SVs;
    SVs_sub(:,i)=[];%remove the according feature
    for j=1:totalSV^2
        param=idxmat(j,:);
        k=param(1);
        l=param(2);
        delta_W2(i)=delta_W2(i)+coef(k)*coef(l)*gkernel(SVs_sub(k,:),SVs_sub(l,:),g);
    end
end
delta_W2=W2-delta_W2;
