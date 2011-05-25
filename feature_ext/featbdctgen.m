function f=featbdctgen(images)
%generate bdct features

N=size(images,1);
f=zeros(N,17);
for i=1:N
    img=images(i,:);
    img=reshape(img,128,128);
    bdct=blkproc(img,[8 8],@dct2);
    x=-8:8;
    y=hist(bdct(:),x);
    y=y/sum(y);
    f(i,:)=y(:)';
end
