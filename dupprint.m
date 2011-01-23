function dupprint(subs,filenames)
%print duplicate images

n_subs=size(subs,1);
for i=1:n_subs
    fprintf('%s\t%s\n',filenames{subs(i,1)},filenames{subs(i,2)});
end
