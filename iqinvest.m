function iqinvest(bdctimgs,N)
%interquartile of sample data investigation
%N: number of sample used to estimate interquartile

K=size(bdctimgs,1);
T=4;
IQs=zeros(N,1);
for i=1:N
    rndidx=ceil(rand*K);
    img=bdctimgs(rndidx,:);
    img=reshape(img,128,128);
    y=img(:,1:end-1)-img(:,2:end);
    y(y>T)=T;
    y(y<-T)=-T;
    quart=quantile(y(:),[0.25 0.75]);
    IQs(i)=quart(2)-quart(1);
    fprintf('IQ=%g\n',IQs(i));
end
fprintf('Median of IQ is %g\n',median(IQs));
