function output=histhackrun2(images,targets)
%batch run of histhack3, using parfor

N=size(images,1);
M=size(targets,1);
randidx=randperm(M);
targets=targets(randidx(1:N),:);

ximages=zeros(N,128^2);
deltas=zeros(N,128^2);
dist_ori=zeros(N,1);
dist=zeros(N,1);
parfor i=1:N    
    fprintf('processing image %d\n',i);
    img=images(i,:);
    img=reshape(img,128,128);
    target=targets(i,:);
    target=reshape(target,128,128);
    [ximg,delta,dist_ori(i),dist(i)]=histhack3(img,target);    
    ximages(i,:)=ximg(:)';
    deltas(i,:)=delta(:)';
end

output.bdctimgs=ximages;
output.deltas=deltas;
output.dist_ori=dist_ori;
output.dist=dist;

