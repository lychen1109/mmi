function w=weightgen(sigma,gamma)
%generate weighting
w=zeros(21,21);
for i=1:21
    for j=1:21
        w(i,j)=1/(sqrt((i-11)^2+(j-11)^2)+sigma)^gamma;
    end
end