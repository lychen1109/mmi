function [data_scale,range]=svmrescale(data,range)
%rescale data to [0 1]

% maxsample=max(data,[],1);
% minsample=min(data,[],1);
% zeroidx=(maxsample==0) & (minsample==0);
% data=data(:,~zeroidx);
if isempty(range)
    range(1,:)=max(data,[],1);
    range(2,:)=min(data,[],1);
end
%data_scale=(data - repmat(min(data,[],1),size(data,1),1)) * spdiags(1./(max(data,[],1)-min(data,[],1))',0,size(data,2),size(data,2));
data_scale=(data-repmat(range(2,:),size(data,1),1))*diag(1./(range(1,:)-range(2,:)));