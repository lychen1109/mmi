function fm=transmatgen(imgs,T)
% extract transition matrix from imgs
% T is the bound
%f calculates the transition probility
%D=f(img,T);

N=size(imgs,1);
m_size=T*2+1;
fm=zeros(m_size,m_size,N);

parfor i=1:N
   img=imgs(i,:);
   img=reshape(img,128,128);   
   bdct=blkproc(img,[8 8],@dct2);
   bdct=abs(round(bdct));
   D=tpm1(bdct,T);
   D=rownorm(D);
   fm(:,:,i)=D;
end

