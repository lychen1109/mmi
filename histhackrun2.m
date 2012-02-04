function output=histhackrun2(images,targets,K)
%batch run of histhack3, using parfor

N=size(images,1);
ximages=zeros(N,128^2);
deltas=zeros(N,128^2);
dist_ori=zeros(N,1);
dist=zeros(N,1);
parfor i=1:N    
    fprintf('processing image %d\n',i);
    img=images(i,:);
    img=reshape(img,128,128);
    target=targets(i,:);
    target=reshape(target,21,21);
    [ximg,delta,dist_ori(i),dist(i)]=histhack3(img,target,K);    
    ximages(i,:)=ximg(:)';
    deltas(i,:)=delta(:)';
end

output.bdctimgs=ximages;
output.deltas=deltas;
output.dist_ori=dist_ori;
output.dist=dist;

