function g=gauss_kernel(u,sigma)
%Gauss Kernel used in max mutual information calculation
sigma=2*sigma^2;
d=size(u,1);
tmp=(1/sigma)*ones(d,1);
tmp2=diag(tmp);
tmp3=(2*pi*sigma)^(d/2);
g=(1/tmp3) * exp(-0.5 * u'*tmp2*u);