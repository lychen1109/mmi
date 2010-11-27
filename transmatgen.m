function fm=transmatgen(imgs,T,type,f)
% extract transition matrix from imgs
% T is the bound
%type=0: with elements outside of T
%type=1: without elements outside of T
%f calculates the transition probility
%D=f(img,T);

N=size(imgs,1);
if type==0
    m_size=T*2+1;
else
    m_size=2*(T-1)+1;
end
fm=zeros(m_size,m_size,N);

for i=1:N
   img=imgs(i,:);
   img=reshape(img,128,128);
   D=f(img,T);
   if type>0
       D=D(2:end-1,2:end-1);
   end
   fm(:,:,i)=D;
end
