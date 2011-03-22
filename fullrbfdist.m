function d=fullrbfdist(x,y,theta)
%distance between two samples with every gamma per feature
%x,y,theta are all row vectors

d=sum(2.^theta(2:82).*(x-y).^2);