function fm=extract_feature(imgs,f)
% extract fth transition matrix from imgs

N=size(imgs,1);
m_size=255*2+1;
fm=zeros(m_size,m_size,N);
for i=1:N
   img=imgs(i,:);
   img=reshape(img,128,128);
   D=tpm(img);
   fm(:,:,i)=D(:,:,f);
end