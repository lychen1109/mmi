function f=corrfeat2(bdctimgs)
%extract correlation feature from bdct images

N=size(bdctimgs,1);
f=zeros(N,1);
for i=1:N
    img=bdctimgs(i,:);
    img=reshape(img,128,128);
    f(i)=pixcorr2(img,5000);
end
