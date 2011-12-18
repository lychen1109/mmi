function images=imgrecover(bdctimgs)
%recover images from bdct coef

images=zeros(size(bdctimgs));
N=size(bdctimgs,1);
for i=1:N
    bdctimg=bdctimgs(i,:);
    bdctimg=reshape(bdctimg,128,128);
    img=bdctdec(bdctimg);
    images(i,:)=img(:)';
end
