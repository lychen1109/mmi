function img=dcnan(img)
%mark dc component as nan

t=false(8,8);
t(1)=true;
t=repmat(t,16,16);
img(t)=nan;
