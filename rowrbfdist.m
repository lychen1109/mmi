function d=rowrbfdist(x,y,theta)
%row rbf kernel distance weighted by kernel params

d=0;
parfor i=1:9
    t=false(9,9);
    t(i,:)=true(1,9);
    d=d+2^theta(i+1)*norm(x(t)-y(t))^2;
end