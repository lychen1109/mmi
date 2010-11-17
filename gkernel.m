function gk=gkernel(x1,x2,g)
%gauss kernel for SVM calculate

gk=exp(-g*norm(x1-x2));