function output=histhackrun2(images,targets,K,T)
%batch run of histhack4, using parfor

N=size(images,1);
ximages=zeros(128,128,N);
deltas=zeros(128,128,N);
dist_ori=zeros(N,1);
dist=zeros(N,1);
parfor i=1:N    
    fprintf('processing image %d\n',i);
    [ximg,delta,dist_ori(i),dist(i)]=histhack4(images(i,:),targets(i,:),K,T);    
    ximages(:,:,i)=ximg;
    deltas(:,:,i)=delta;
end

output.ximages=ximages;
output.deltas=deltas;
output.dist_ori=dist_ori;
output.dist=dist;

