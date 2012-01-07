function [markovfeat]=markovmarggen(images)
%markov and marginal features

N=size(images,1);
markovfeat=zeros(N,49);
%margfeat=zeros(N,7);
for i=1:N
    img=images(i,:);
    img=reshape(img,128,128);    
    D=tpm1(img,3);
    %margfeat(i,:)=sum(D,2)';
    for j=1:7
        sumd=sum(D(j,:));
        if sumd>0
            D(j,:)=D(j,:)/sumd;
        end
    end
    markovfeat(i,:)=D(:)';
    %margfeat(i,:)=sum(D);
end

    
    