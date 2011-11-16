function [ac,moddouts]=histhackrun3(data,model,range,Maxiter)
%batch run of histhackm2step, using parfor

nworker=matlabpool('size');
if nworker<2
    error('Increase the performance by launching matlabpool\n');
else
    fprintf('Running on %d workers\n',nworker);
end

datavalidate=data.datavalidate;
labelvalidate=data.labelvalidate;
ac=svmcheck(labelvalidate,datavalidate,range);

ximages=datavalidate(labelvalidate==0,:);
N=size(ximages,1);

%mark dc component as modified
mask=false(8,8);
mask(1,1)=true;
mask=repmat(mask,16,16);
modified=repmat(mask(:)',N,1);

notfinish=true(N,1);
moddouts=zeros(N,Maxiter);
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
            [ximg,modifiedtmp,~,output]=histhacksvmstep(simg,modifiedtmp,model,range);
            ximages(i,:)=ximg(:)';
            modified(i,:)=modifiedtmp(:)';
            notfinish(i)=(output.n_mod>0);
            moddouts(i,iter)=output.moddout;
        end
    end
    datavalidate(labelvalidate==0,:)=ximages;
    actmp=svmcheck(labelvalidate,datavalidate,range);
    ac=cat(1,ac,actmp);    
end


