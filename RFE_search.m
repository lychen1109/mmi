function history=RFE_search(label,data,history,featinc)
%use RFE algotirhm to remove useless feature
%featinc: features to include

[bestc,bestg,bestcv]=svmgrid(data(:,featinc),label,0,2,-3:2:11,-11:2:1,500);
cv_tmp=history.cv;
history.cv=[cv_tmp;bestcv];

cmd=['-c ' num2str(bestc) ' -g ' num2str(bestg)];
model=svmtrain(label,data(:,featinc),cmd);

delta=zeros(size(featinc));
delta_W2=RFE_evaluate(model);
delta(featinc)=delta_W2(:);
delta_tmp=history.delta;
history.delta=[delta_tmp;delta];

feat_tmp=history.feat;
history.feat=[feat_tmp;featinc];

