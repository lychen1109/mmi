function [ximages,returntypes]=histhackrun3(images,samplevalues,model,range)
%batch run of histhack* function, using parfor

nworker=matlabpool('size');
if nworker<2
    error('Increase the performance by launching matlabpool\n');
else
    fprintf('Running on %d workers\n',nworker);
end

N=size(images,1);
ximages=zeros(size(images));
returntypes=zeros(N,1);

parfor i=1:N
    fprintf('processing image %d\n',i);
    simg=images(i,:);
    simg=reshape(simg,128,128);    
    [ximg,~,returntypes(i)]=histhacksvm2(simg,samplevalues(i),model,range);
    ximages(i,:)=ximg(:)';    
end

save histhacksvm2result ximages returntypes





