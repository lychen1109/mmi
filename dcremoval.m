function img=dcremoval(img)
%remove dc component of an image

t=ones(8,8);
t(1)=0;
T=repmat(t,16,16);
img=img.*T;
