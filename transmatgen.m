function fm=transmatgen(imgs,T)
% extract fth transition matrix from imgs
% T is the bound

N=size(imgs,1);
if T>0
    m_size=T*2+1;
else
    m_size=2*255+1;
end
fm=zeros(m_size,m_size,N);

for i=1:N
   img=imgs(i,:);
   img=reshape(img,128,128);
   D=tpm1(img,T);
   fm(:,:,i)=D;
end
