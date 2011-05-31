function bdctimgs=bdctgen(imgs)
%generate bdct array from images

N=size(imgs,1);
bdctimgs=zeros(N,128^2);
for i=1:N
    img=imgs(i,:);
    img=reshape(img,128,128);
    bdctimg=blkproc(img,[8 8],@dct2);
    bdctimg=abs(bdctimg);
    bdctimgs(i,:)=bdctimg(:)';
end
