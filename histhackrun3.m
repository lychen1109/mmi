function ac=histhackrun3(data,gm1,gm2,Maxiter)
%batch run of histhackm2step, using parfor

nworker=matlabpool('size');
if nworker<2
    error('Increase the performance by launching matlabpool\n');
else
    fprintf('Running on %d workers\n',nworker);
end

datavalidate=data.datavalidate;
labelvalidate=data.labelvalidate;
ac=svmcheck(labelvalidate,datavalidate);

ximages=datavalidate(labelvalidate==0,:);
N=size(ximages,1);
modified=false(N,128^2);
notfinish=true(N,1);
iter=0;
while any(notfinish) && iter<Maxiter
    iter=iter+1;
    fprintf('iter=%d\n',iter);
    fprintf('percentage notfinished=%g\n',sum(notfinish)/N);
    parfor i=1:N
        if notfinish(i)
            fprintf('processing image %d\n',i);
            simg=ximages(i,:);
            simg=reshape(simg,128,128);
            modifiedtmp=modified(i,:);
            modifiedtmp=reshape(modifiedtmp,128,128);
            [ximg,modifiedtmp,output]=histhackm2step(simg,modifiedtmp,gm1,gm2);
            ximages(i,:)=ximg(:)';
            modified(i,:)=modifiedtmp(:)';
            notfinish(i)=(output.n_mod>0);
        end
    end
    datavalidate(labelvalidate==0,:)=ximages;
    actmp=svmcheck(labelvalidate,datavalidate);
    ac=cat(2,ac,actmp);    
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