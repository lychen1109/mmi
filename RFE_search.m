function history=RFE_search(label,data)
%use RFE algotirhm to remove feature one by one

[bestc,bestg,bestcv]=svmgrid(data,label,0);
history.cv=bestcv;
cmd=['-c ' num2str(bestc) ' -g ' num2str(bestg)];
model=svmtrain(label,data,cmd);
delta_W2=RFE_evaluate(model);
history.delta=delta_W2;
