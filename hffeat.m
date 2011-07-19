function h=hffeat(bdctimg)
%high frequency feat

bdctimg=blkproc(bdctimg,[8 8],@highpass);
X=0:10;
h=hist(bdctimg(:),X)/(16*16*28);
