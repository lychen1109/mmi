function sigma=mmi_sigma2(label,y)
%half of average distance within class

y0=y(label==0,:);
y1=y(label==1,:);
n_y0=size(y0,1);
n_y1=size(y1,1);

n_pair_y0=0;
dist_y0=0;
for i=1:n_y0-1
    for j=i+1:n_y0
        n_pair_y0=n_pair_y0+1;
        dist_y0=dist_y0+norm(y0(i,:)-y0(j,:));
    end
end

n_pair_y1=0;
dist_y1=0;
for i=1:n_y1-1
    for j=i+1:n_y1
        n_pair_y1=n_pair_y1+1;
        dist_y1=dist_y1+norm(y1(i,:)-y1(j,:));
    end
end

sigma=(dist_y0/n_pair_y0+dist_y1/n_pair_y1)/2;
