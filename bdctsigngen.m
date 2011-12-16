function bdctsigns=bdctsigngen(images)
%generate bdctsign from images

N=size(images,1);
bdctsigns=zeros(size(images));
for i=1:N
    img=images(i,:);
    img=reshape(img,128,128);
    bdctimg=blkproc(img,[8 8],@dct2);
    bdctimg=round(bdctimg);
    bdctsign=sign(bdctimg);
    bdctsign(bdctsign==0)=1;
    bdctsigns(i,:)=bdctsign(:)';
end
