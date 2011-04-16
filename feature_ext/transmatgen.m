function fm=transmatgen(imgs,T,f)
% extract transition matrix from imgs
% T is the bound
%f calculates the transition probility
%D=f(img,T);

N=size(imgs,1);
m_size=T*2+1;
fm=zeros(m_size,m_size,N);

for i=1:N
   img=imgs(i,:);
   img=reshape(img,128,128);
   D=f(img,T);   
   fm(:,:,i)=D;
end
