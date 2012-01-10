function array=rownorm(array)
%normalize every row of the array with the sum

N=size(array,1);
for i=1:N
    if sum(array(i,:))>0
        array(i,:)=array(i,:)/sum(array(i,:));
    end
end
