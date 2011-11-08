function ac=histhackrun3(data,gm1,gm2)
%batch run of histhackm, using parfor

nworker=matlabpool('size');
if nworker<2
    error('Increase the performance by launching matlabpool\n');
else
    fprintf('Running on %d workers\n',nworker);
end

datavalidate=data.datavalidate;
labelvalidate=data.labelvalidate;
ac=zeros(21,5);
ac(1,:)=svmcheck(labelvalidate,datavalidate);

ximages=datavalidate(labelvalidate==0,:);
N=size(ximages,1);
modified=false(N,128^2);
for k=1:20
    for i=1:N
        fprintf('processing image %d\n',i);
        simg=ximages(i,:);
        simg=reshape(simg,128,128);
        modifiedtmp=modified(i,:);
        modifiedtmp=reshape(modifiedtmp,128,128);
        [ximg,modifiedtmp]=histhackm2step(simg,modifiedtmp,gm1,gm2);
        ximages(i,:)=ximg(:)';
        modified(i,:)=modifiedtmp(:)';
    end
    datavalidate(labelvalidate==0,:)=ximages;
    ac(k+1,:)=svmcheck(labelvalidate,datavalidate);
end


function ac=svmcheck(label,images)
%feature extraction and svm test

N=size(images,1);
tm=transmatgen(images,3,@tpm1);
feat=reshape(tm,49,N)';
feat=svmrescale(feat);
cvpk=cvpartition(label,'kfold',5);
thetas=runsvmgridk(label,feat,cvpk,0:2:10,-6:2:6);
ac=svmtestk(label,feat,cvpk,median(thetas));