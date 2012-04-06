function output=histhackrun2(images,targets,beta1,beta2,K,T,B)
%batch run of histhack*, using parfor

N=size(images,1);
ximages=zeros(128,128,N);

parfor i=1:N    
    fprintf('processing image %d\n',i);
    [ximages(:,:,i)]=histhack3c(images(i,:),targets(i,:),beta1,beta2,K,T,B);
end

output.ximages=ximages;


