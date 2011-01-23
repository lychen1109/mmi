function subs=subfilter(subs)
%filter out those subs not on diag

n_sub=size(subs,1);
subs=[subs zeros(n_sub,1)];
for i=1:n_sub
    if subs(i,1)>subs(i,2)
        subs(i,3)=1;
    end
end
subs=subs(subs(:,3)==1,1:2);