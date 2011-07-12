function iqinvest2(bdctimgs)
%interquartile of sample data investigation

K=size(bdctimgs,1);
T=4;
    
bdctimgs=reshape(bdctimgs',128,128,K);
y=bdctimgs(:,1:end-1,:)-bdctimgs(:,2:end,:);
y(y>T)=T;
y(y<-T)=-T;

quart=quantile(y(:),[0.25 0.75]);
fprintf('1st and 3rd quantile of samples are: %g, %g\n',quart(1),quart(2));

m=mean(y(:));
fprintf('Mean of samples are %g\n',m);

IQ=quart(2)-quart(1);
fprintf('IQ=%g\n',IQ);

fprintf('width of bin is %g\n',2*IQ*(127*128)^(-1/3));
