function [I,G]=mymi3s(label,w,x,pairs,sigma)
%sample version of mymi3

n_pairs=size(pairs,1);
y=x*w;
I=0;
G=0;
GK0=gauss_kernel(0,sigma);
for i=1:n_pairs
    i1=pairs(i,1);
    i2=pairs(i,2);
    if label(i1)==label(i2)
        continue;
    end
    D=(y(i1,:)-y(i2,:))';
    GKD=gauss_kernel(D,sigma);
    I=I+0.25*(GK0-GKD);
    G=G-(0.125/sigma^2)*GKD*D*(x(i2,:)-x(i1,:));
end
G=G';