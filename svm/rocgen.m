function rocgen(label,feat,cvp,threshold)
%generate roc curve

labeltrain=label(cvp.training);
datatrain=feat(cvp.training,:);
cvp5=cvpartition(labeltrain,'kfold',5);
dvalues=zeros(size(labeltrain));
for i=1:5    
    [~,~,dvalues(cvp5.test(i))]=mysvmfun(labeltrain(cvp5.training(i)),datatrain(cvp5.training(i),:),labeltrain(cvp5.test(i)),datatrain(cvp5.test(i),:),[8 -6]);
end
predict=ones(size(dvalues));
predict(dvalues<threshold)=0;
ac=sum(predict==labeltrain)/length(labeltrain);
tp=sum(labeltrain==0 & predict==labeltrain)/sum(labeltrain==0);
fp=sum(labeltrain==1 & predict==0)/sum(labeltrain==1);
fprintf('accuracy=%g, tp=%g, fp=%g\n',ac,tp,fp);
