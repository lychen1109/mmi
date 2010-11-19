function W2=model_W2(model,feat)
%calculate W2 of model

totalSV=model.totalSV;
coef=model.sv_coef;
SVs=model.SVs;
g=model.Parameters(4);
idxmat=zeros(totalSV^2,2);
idx=0;
W2=0;
for i=1:totalSV
    for j=1:totalSV
        idx=idx+1;
        idxmat(idx,:)=[i j];
    end
end

parfor i=1:totalSV^2
    k=idxmat(i,1);
    l=idxmat(i,2);
    W2=W2+coef(k)*coef(l)*gkernel(SVs(k,feat==1),SVs(l,feat==1),g);
end

