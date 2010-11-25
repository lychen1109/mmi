function x_res=orthres(x,w)
%orthogonal residual

N=size(x,1);
x_res=x-x*w*repmat(w',N,1);