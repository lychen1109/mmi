function [t1,t2]=perfcompare(images)
%compare the performance of two types of features: TPM and SD hist

N=size(images,1);
t1=zeros(N,1);
t2=zeros(N,1);
for i=1:N
    img=images(i,:);
    img=reshape(img,128,128);
    tic;D=tpm1d(img,4,0,1);t1(i)=toc;
    tic;h=sdhist(img,4,0);t2(i)=toc;
    fprintf('processed %dth image\n',i);
end

    