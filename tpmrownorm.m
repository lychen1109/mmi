function tm=tpmrownorm(tm)
%normalize transition probability matrix in every row

M=size(tm,1);
for i=1:M
    rowsum=sum(tm(i,:));
    if rowsum>0
        tm(i,:)=tm(i,:)/rowsum;
    end
end

