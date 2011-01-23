function dupcheck(subs,images)
%data duplication check

n_subs=size(subs,1);
for i=1:n_subs
    img1=images(subs(i,1),:);
    img2=images(subs(i,2),:);
    if isequal(img1,img2)
        fprintf('image %d and %d is same\n',subs(i,1),subs(i,2));
    else
        fprintf('image %d and %d is different.\n',subs(i,1),subs(i,2));
    end
end
