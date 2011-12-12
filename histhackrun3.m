function [bdctimgs,dist_ori,dist]=histhackrun3(images,timages)
%batch run of histhack* function, using parfor

nworker=matlabpool('size');
if nworker<2
    error('Increase the performance by launching matlabpool\n');
else
    fprintf('Running on %d workers\n',nworker);
end

N=size(images,1);
bdctimgs=zeros(size(images));
dist_ori=zeros(N,1);
dist=zeros(N,1);

parfor i=1:N
    fprintf('processing image %d\n',i);
    simg=images(i,:);
    simg=reshape(simg,128,128);
    aimg=timages(i,:);
    aimg=reshape(aimg,128,128);
    [bdctimg,dist_ori(i),dist(i)]=histhack3(simg,aimg);
    bdctimgs(i,:)=bdctimg(:)';    
end






