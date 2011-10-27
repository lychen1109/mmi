function [ximages,outputs]=histhackrun(spfilenames,gm1,gm2,varargin)
%batch run of histhackm

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
imgidx=0;
while imgidx<N
    if imgidx+nworker<=N
        nparallel=nworker;
    else
        nparallel=N-imgidx;
    end
    fprintf('processing image %d-%d\n',imgidx+1,imgidx+nparallel);
    spmd
        if labindex<=nparallel
            [ximg,output]=histhackm2(spfilenames{imgidx+labindex},gm1,gm2,'root',root);
        end
    end
    for i=1:nparallel
        ximglocal=ximg{i};        
        ximages(imgidx+i,:)=ximglocal(:)';
        outputs(imgidx+i)=output{i};
    end
    imgidx=imgidx+nparallel;
end
