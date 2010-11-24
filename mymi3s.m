function [I,G]=mymi3s(label,w,x,pairs,sigma)
%sample version of mymi3

n_pairs=size(pairs,1);
N=size(label,1);
J0=sum(label==0);
J1=N-J0;
J=(J0^2+J1^2)/N^2;
y=x*w;
I=0;
G=0;

parfor i=1:n_pairs
    sample_pair=pairs(i,:);
    i1=sample_pair(1);
    i2=sample_pair(2);
    
    ly=y;
    lx=x;
    llabel=label;
    D=(ly(i1,:)-ly(i2,:))';
    GK=gauss_kernel(D,sigma);
    if llabel(i1)==llabel(i2)
        Vin=GK;
        Fin=GK*D*lx(i2,:)/sigma^2;
    else
        Vin=0;
        Fin=0;
    end
    Vall=J*GK;
    Fall=J*GK*D*lx(i2,:)/sigma^2;
    
    if llabel(i1)==0
        Jp=J0;
    else
        Jp=J1;
    end
    if llabel(i2)==0
        Jc=J0;
    else
        Jc=J1;
    end
    Vbtw=Jp*GK/N;
    Fbtw=(Jp+Jc)*GK*D*lx(i2,:)/(2*N*sigma^2);
    
    I=I+Vin+Vall-2*Vbtw;
    G=G+Fin+Fall-2*Fbtw;    
end
G=G';