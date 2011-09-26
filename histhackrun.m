function [ximages,n_mods]=histhackrun(imagepairs,sigma)
%batch run of histhack2

N=size(imagepairs,1);
ximages=zeros(N,128^2);
n_mods=zeros(N,1);
for i=1:N
    fprintf('processing image %d\n',i);
    [ximg,n_mods(i)]=histhack2(imagepairs{i,2},imagepairs{i,1},sigma);
    ximages(i,:)=ximg(:)';
end
