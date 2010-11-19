function delta_W2=RFE_evaluate(model)
%evaluate delta W2 according to removal of every single feature

n_feat=size(model.SVs,2);
delta_W2=zeros(1,n_feat);
feat=ones(1,n_feat);
W2=model_W2(model,feat);

for i=1:n_feat
    feats=feat;
    feats(i)=0;
    delta_W2(i)=W2-model_W2(model,feats);
end

