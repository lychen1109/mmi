function dvalues=checkdvalues(model,range,data)
%check dvalues of validation set under the trained model

images=data.datavalidate;
label=data.labelvalidate;
simages=images(label==0,:);
N_sp=size(simages,1);
tm=transmatgen(simages,3);
feat=reshape(tm,49,N_sp)';
feat=svmrescale(feat,range);
[~,~,dvalues]=svmpredict(label(label==0),feat,model);

