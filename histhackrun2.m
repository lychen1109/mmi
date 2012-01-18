function output=histhackrun2(images,gm,PCAstruct,target,randidxs)
%batch run of histhackm, using parfor

N=size(images,1);
ximages=zeros(N,128^2);
deltas=zeros(N,128^2);
logpdfori=zeros(N,1);
logpdfnew=zeros(N,1);
parfor i=1:N    
    fprintf('processing image %d\n',i);
    img=images(i,:);
    img=reshape(img,128,128);
    [ximg,delta,logpdfori(i),logpdfnew(i)]=histhackm(img,gm,PCAstruct,randidxs(i,:),1,target(i));    
    ximages(i,:)=ximg(:)';
    deltas(i,:)=delta(:)';
end

output.bdctimgs=ximages;
output.randidxs=randidxs;
output.deltas=deltas;
output.logpdfori=logpdfori;
output.logpdfnew=logpdfnew;

