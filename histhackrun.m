function [ximages,n_mods,modratios,psnrfinals]=histhackrun(imagepairs,sigma,varargin)
%batch run of histhack2

root='C:\data\ImSpliceDataset\';
nvar=length(varargin);
for i=1:nvar/2
    switch varargin{2*i-1}
        case 'root'
            root=varargin{2*i};
    end
end

N=size(imagepairs,1);
ximages=zeros(N,128^2);
n_mods=zeros(N,1);
modratios=zeros(N,1);
psnrfinals=zeros(N,1);
for i=1:N
    fprintf('processing image %d\n',i);
    [ximg,n_mods(i),modratios(i),psnrfinals(i)]=histhack2(imagepairs{i,2},imagepairs{i,1},sigma,'root',root);
    ximages(i,:)=ximg(:)';
end
