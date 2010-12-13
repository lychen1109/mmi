function dist=avgdist(x)
%calculate average distance between samples in x

n=size(x,1);
iter=0;
dist=0;
for i=1:n-1
    for j=i+1:n
       iter=iter+1;
       dist=dist+norm(x(i,:)-x(j,:));
    end
end
dist=dist/iter;