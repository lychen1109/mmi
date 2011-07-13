function y=bdctpreproc(bdctimgs)
%preprocess bdctcoeff to generate y

K=size(bdctimgs,1);
T=4;
bdctimgs=reshape(bdctimgs',128,128,K);
y=bdctimgs(:,1:end-1,:)-bdctimgs(:,2:end,:);
y(y>T)=T;
y(y<-T)=-T;
