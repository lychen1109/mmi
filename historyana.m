function [bestaccu finalaccu]=historyana(histories)
%analysis history cells

N=length(histories);
bestaccu=zeros(N,1);
finalaccu=zeros(N,1);
for i=1:N
    history=histories{i};
    finalaccu(i)=history.accutests(end);
    [~,I]=max(history.accuvalis);
    bestaccu(i)=history.accutests(I);
end
