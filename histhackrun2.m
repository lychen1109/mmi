function [ximages]=histhackrun2(images,gm,PCAstruct)
%batch run of histhackm, using parfor

N=size(images,1);
ximages=zeros(N,128^2);
parfor i=1:N    
    fprintf('processing image %d\n',i);
    img=images(i,:);
    img=reshape(img,128,128);
    [ximg]=histhackm(img,gm,PCAstruct);    
    ximages(i,:)=ximg(:)';    
end
