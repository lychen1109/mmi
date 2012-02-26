function images=bdctdecall(bdctimgs)
%transform to spatial domain for all images

N=size(bdctimgs,1);
bdctimgs=reshape(bdctimgs',128,128,N);
images=zeros(size(bdctimgs));
for i=1:N
    images(:,:,i)=bdctdec(bdctimgs(:,:,i));
end
images=reshape(images,128^2,N)';