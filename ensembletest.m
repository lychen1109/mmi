function err=ensembletest(label,feat,k)
%test performance of ensemble classifier

err=zeros(k,1);

for i=1:k    
    model=ensemble_wrap(feat(label==1,:), feat(label==0,:),'unique');
    err(i)=model.testing_error;    
    fprintf('err of set %d is %g\n',i,err(i));
end
