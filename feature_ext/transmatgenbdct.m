function fm=transmatgenbdct(bdctimgs,T)
% extract transition matrix from bdctimgs
% T is the bound

bdctimgs=abs(bdctimgs);
N=size(bdctimgs,1);
m_size=T*2+1;
fm=zeros(m_size,m_size,N);

parfor i=1:N
   bdctimg=bdctimgs(i,:);
   bdctimg=reshape(bdctimg,128,128);
   D=tpm1(bdctimg,T);
   fm(:,:,i)=D;
end

