function dvalues=checkdvalues(model,range,data)
%check dvalues of validation set under the trained model

images=data.datavalidate;
label=data.labelvalidate;
N=size(images,1);
tm=transmatgen(images,3);
feat=reshape(tm,49,N)';
feat=svmrescale(feat,range);
[~,~,dvalues]=svmpredict(label,feat,model);

