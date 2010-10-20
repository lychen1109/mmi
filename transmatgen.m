function fm=transmatgen(imgs,f,T)
% extract fth transition matrix from imgs
% f is direnction of transmat
% T is the bound

N=size(imgs,1);
m_size=T*2+1;
fm=zeros(m_size,m_size,N);
origin=256;%origin poition
for i=1:N
   img=imgs(i,:);
   img=reshape(img,128,128);
   D=tpm(img);
   fm(:,:,i)=D(origin+(-T:T),origin+(-T:T),f);
end