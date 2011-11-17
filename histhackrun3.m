function [datavalidate,modified,tm,output]=histhackrun3(data,model,range)
%batch run of histhackm2step, using parfor

nworker=matlabpool('size');
if nworker<2
    error('Increase the performance by launching matlabpool\n');
else
    fprintf('Running on %d workers\n',nworker);
end

datavalidate=data.datavalidate;
labelvalidate=data.labelvalidate;

ximages=datavalidate(labelvalidate==0,:);
N=size(ximages,1);
modified=false(N,128^2);
dout_ori=zeros(N,1);
moddout=zeros(N,1);
n_mod=zeros(N,1);
tm=zeros(N,49);

parfor i=1:N
    fprintf('processing image %d\n',i);
    simg=ximages(i,:);
    simg=reshape(simg,128,128);    
    [ximg,modifiedtmp,tmtmp,outputtmp]=histhacksvmstep(simg,model,range);
    ximages(i,:)=ximg(:)';
    modified(i,:)=modifiedtmp(:)';
    tm(i,:)=tmtmp(:)';
    dout_ori(i)=outputtmp.dout_ori;
    moddout(i)=outputtmp.moddout;
    n_mod(i)=outputtmp.n_mod;
end
datavalidate(labelvalidate==0,:)=ximages;
output.dout_ori=dout_ori;
output.moddout=moddout;
output.n_mod=n_mod;




