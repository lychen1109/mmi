function [gt]=grouptemplate(group,theta)
%grouptemplate generate group template for feature rescaling

group=group(:)';
n_group=max(group);
gt=zeros(size(group));
for i=1:n_group
    gt(group==i)=theta(i+1);
end
gt=sqrt(2.^gt);
