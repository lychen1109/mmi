function bdctimgs=hfana(bdctimgs)
%high frequency analysis
%irrelevant modes are marked as nan

K=size(bdctimgs,1);
for i=1:K
    img=bdctimgs(i,:);
    img=reshape(img,128,128);
    img=blkproc(img,[8 8],@highpass);
    bdctimgs(i,:)=img(:)';
end
