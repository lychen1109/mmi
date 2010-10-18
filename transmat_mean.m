function m=transmat_mean(autrain,sptrain)
%calculate mean of transmat of both au and sp training samples

if matlabpool('size')==0
   matlabpool; 
end

imgs=[autrain;sptrain];
NUMIMG=size(imgs,1);
m=zeros(511,511);
imgsize=128;
transmat_direction=1;

parfor i=1:NUMIMG
    img=imgs(i,:);
    img=reshape(img,imgsize,imgsize);
    D=tpm(img);
    D=D(:,:,transmat_direction);
    m=m+D;
end

m=m/NUMIMG;