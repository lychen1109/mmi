function s=sigmoid(y,f,A,B)
%sigmoid function to smooth SVM output

s=1./(1+exp(y.*(A*f+B)));