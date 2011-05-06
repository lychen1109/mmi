function [thetas_array]=cell2array(thetas)
%transfer thetas from cell to array

N=size(thetas,1);
thetas_array=zeros(N,3);
for i=1:N
    thetas_array(i,:)=thetas{i};
end
