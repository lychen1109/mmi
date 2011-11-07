function [gm1,gm2]=modelselect(data)
%select best number of GMM component via cross validation

sample=data.datamodel;
label=data.labelmodel;
T=3;
tm=transmatgen(sample,T,@tpm1);
N=length(label);
feat=reshape(tm,(2*T+1)^2,N)';
feat=feat(:,1:end-1);
cvp=cvpartition(label,'kfold',5);
ac=zeros(7,1);
for k=2:8    
    for i=1:5
        label_train=label(cvp.training(i));
        data_train=feat(cvp.training(i),:);
        label_test=label(cvp.test(i));
        data_test=feat(cvp.test(i),:);
        actmp=gmmclassify(label_train,data_train,label_test,data_test,k);
        ac(k-1)=ac(k-1)+actmp;
    end
    fprintf('average cross validation accuracy of %d components is %g\n',k,ac(k-1)/5);
end

[~,K]=max(ac);
fprintf('use %d component GMM\n',K+1);
gm1=gmmgen(feat(label==1,:),K+1);
gm2=gmmgen(feat(label==0,:),K+1);

