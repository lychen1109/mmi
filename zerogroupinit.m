function bin_mi=zerogroupinit(group_idx,label,sigma,transmat,bin_mi)
%calculate MI of group 0

points=find(group_idx==0);
NUMPOINTS=length(points);
T=13;

for i=1:NUMPOINTS    
    if bin_mi(points(i))==0
        [sx,sy]=ind2sub(size(group_idx),points(i));
        feature=transmat(sx,sy,:);
        I=mymi3(label,1,feature(:),sigma,0);
        fprintf('MI at (%d,%d) = %e\n',sx-1-T,sy-1-T,I);
        bin_mi(points(i))=I;
    end    
end