function x_res=orthres(x,w)
%orthogonal residual

N=size(x,1);
coeff=x*w;
x_res=zeros(size(x));
for i=1:N
    x_res(i,:)=x(i,:)-coeff(i)*w';
end
