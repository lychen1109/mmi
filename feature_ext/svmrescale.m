function data_scale=svmrescale(data)
%rescale data to [0 1]

maxsample=max(data);
minsample=min(data);
zeroidx=(maxsample==0) && (minsample==0);
data=data(:,~zeroidx);
%data_scale=(data - repmat(min(data,[],1),size(data,1),1)) * spdiags(1./(max(data,[],1)-min(data,[],1))',0,size(data,2),size(data,2));
data_scale=(data-repmat(min(data,[],1),size(data,1),1))*diag(1./(max(data,[],1)-min(data,[],1)));