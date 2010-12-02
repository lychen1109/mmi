function [I,g]=mymi3s(label,w,x,pairs,sigma)
%sample version of mymi3

n_pairs=size(pairs,1);
I=0;
g=zeros(size(w'));

parfor i=1:n_pairs    
    I=I+I_calc(label,w,x,pairs(i,:),sigma);    
    g=g+g_calc(label,w,x,pairs(i,:),sigma);    
end
g=g';

function I1=I_calc(label,w,x,pair,sigma)
%calculate I of single pair
i1=pair(1);
i2=pair(2);
N=size(label,1);
J0=sum(label==0);
J1=N-J0;
J=(J0^2+J1^2)/N^2;
y=x*w;
D=(y(i1,:)-y(i2,:))';
GK=gauss_kernel(D,sigma);
if label(i1)==label(i2)
    Vin=GK/N^2;
else
    Vin=0;
end
Vall=J*GK/N^2;
if label(i1)==0
    Jp=J0;
else
    Jp=J1;
end
Vbtw=Jp*GK/N^3;
I1=Vin+Vall-2*Vbtw;

function g1=g_calc(label,w,x,pair,sigma)
%calculate g of singla pair
i1=pair(1);
i2=pair(2);
N=size(label,1);
J0=sum(label==0);
J1=N-J0;
J=(J0^2+J1^2)/N^2;
y=x*w;
D=(y(i1,:)-y(i2,:))';
GK=gauss_kernel(D,sigma);
if label(i1)==label(i2)
    Fin=GK*D*x(i2,:)/(2*sigma^2*N^2);
else
    Fin=0;
end
Fall=J*GK*D*x(i2,:)/(2*sigma^2*N^2);
if label(i1)==0
    Jp=J0;
else
    Jp=J1;
end
Fbtw=Jp*GK*D*x(i2,:)/(2*N^3*sigma^2);
g1=Fin+Fall-2*Fbtw;
