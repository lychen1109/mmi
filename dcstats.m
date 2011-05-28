function h=dcstats(img)
%stats of dc component

dc=zeros(1,16^2);
idx=0;
for i=1:16
    for j=1:16
        idx=idx+1;
        dc(idx)=img((i-1)*8+1,(j-1)*8+1);
    end
end
h=hist(dc,7:20);
