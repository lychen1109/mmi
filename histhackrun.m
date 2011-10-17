function [ximages,n_mods,modlogpdfs,psnrfinals]=histhackrun(spfilenames,gm,varargin)
%batch run of histhackm

root='C:\data\ImSpliceDataset\';
nvar=length(varargin);
for i=1:nvar/2
    switch varargin{2*i-1}
        case 'root'
            root=varargin{2*i};
    end
end

N=size(spfilenames,1);
ximages=zeros(N,128^2);
n_mods=zeros(N,1);
modlogpdfs=zeros(N,1);
psnrfinals=zeros(N,1);
for i=1:N
    fprintf('processing image %d\n',i);
    [ximg,n_mods(i),modlogpdfs(i),psnrfinals(i)]=histhackm(spfilenames{i},gm,'root',root);
    ximages(i,:)=ximg(:)';
end
