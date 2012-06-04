function mat=normmat(mat)
%normalized matrix

N=sum(sum(mat));
mat=mat/N;
