function output=histhackrun2(images,gm,PCAstruct)
%batch run of histhackm, using parfor

N=size(images,1);
ximages=zeros(N,128^2);
randidxs=zeros(N,127*128);
deltas=zeros(N,128^2);
logpdfori=zeros(N,1);
logpdfnew=zeros(N,1);
parfor i=1:N    
    fprintf('processing image %d\n',i);
    img=images(i,:);
    img=reshape(img,128,128);
    randidx=randperm(127*128);
    randidxs(i,:)=randidx;
    [ximg,delta,logpdfori(i),logpdfnew(i)]=histhackm(img,gm,PCAstruct,randidx,1,inf);    
    ximages(i,:)=ximg(:)';
    deltas(i,:)=delta(:)';
end

output.bdctimgs=ximages;
output.randidxs=randidxs;
output.deltas=deltas;
output.logpdfori=logpdfori;
output.logpdfnew=logpdfnew;

