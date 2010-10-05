function sigma=mmi_sigma(y)
% sigma used in max mutual information calculation. Sigma is half of the
% distance between two farthest samples.

N=size(y,1);
max_dist=0;

for i=1:N
    for j=1:N
        dist=norm(y(i,:)-y(j,:));
        if dist > max_dist
           max_dist=dist; 
        end
    end
end

sigma=max_dist/2;