function [A,B]=logistregdirect(~,dvalues)
%direct method to decide A and B

B=0;
rho=std(dvalues,1);
A=-10/rho;