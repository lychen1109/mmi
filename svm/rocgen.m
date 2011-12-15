function rocgen(label,dvalues,threshold)
%generate roc curve

predict=ones(size(dvalues));
predict(dvalues<threshold)=0;
ac=sum(predict==label)/length(label);
tp=sum(label==0 & predict==0)/sum(label==0);
fp=sum(label==1 & predict==0)/sum(label==1);
fprintf('accuracy=%g, tp=%g, fp=%g\n',ac,tp,fp);
