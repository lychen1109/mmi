function [ximages,outputs]=histhackrun2(spfilenames,gm1,gm2,varargin)
%batch run of histhackm, using parfor

root='C:\data\ImSpliceDataset\';
nvar=length(varargin);
for i=1:nvar/2
    switch varargin{2*i-1}
        case 'root'
            root=varargin{2*i};
    end
end
nworker=matlabpool('size');
if nworker<2
    error('Increase the performance by launching matlabpool\n');
else
    fprintf('Running on %d workers\n',nworker);
end

N=size(spfilenames,1);
ximages=zeros(N,128^2);
parfor i=1:N    
    fprintf('processing image %d\n',i);
    [ximg,outputs(i)]=histhackm2(spfilenames{i},gm1,gm2,'root',root);    
    ximages(i,:)=ximg(:)';    
end
