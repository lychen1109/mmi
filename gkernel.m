function gk=gkernel(x1,x2,g)
%gauss kernel for SVM calculate

x1=x1(:);
x2=x2(:);
dx=(x1-x2)'*(x1-x2);
gk=exp(-g*dx);