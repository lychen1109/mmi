function printsubs(subs,filenames)
%print filenames of duplicated images

N=size(subs,1);
for i=1:N
    fprintf('%s\t%s\n',filenames{subs(i,1)},filenames{subs(i,2)});
end
