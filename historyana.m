function [finalaccu]=historyana(histories)
%analysis history cells

N=length(histories);
finalaccu=zeros(N,1);
for i=1:N
    history=histories{i};
    finalaccu(i)=history.accutests(end);    
end
