function dvalues=checkdvalues(model,range,images)
%check dvalues of validation set under the trained model

N=size(images,1);
tm=transmatgen(images,3);
feat=reshape(tm,49,N)';
feat=svmrescale(feat,range);
[~,~,dvalues]=svmpredict(zeros(N,1),feat,model);

