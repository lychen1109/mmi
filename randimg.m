function randimg(images)
%show rand image in images

N=size(images,1);
idx=ceil(N*rand);
img=images(idx,:);
img=reshape(img,128,128);
imagesc(img),colormap gray