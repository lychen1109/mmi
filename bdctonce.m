function bimages=bdctonce(images)
%bdct and inverse bdct one time for oritinal image

bimages=zeros(size(images));
N=size(images,1);
for i=1:N
    img=images(i,:);
    img=reshape(img,128,128);
    bdct=blkproc(img,[8 8],@dct2);
    bdct=round(bdct);
    bimg=bdctdec(bdct);
    bimages(i,:)=bimg(:)';
end

    
    