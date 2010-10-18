function features=group_feature_extract(group_idx,grp,autrain,sptrain)
%extract feature to be transformed

imgs=[autrain;sptrain];
samplesize=size(imgs,1);

points=find(group_idx==grp);
pointnum=length(points);

features=zeros(samplesize,pointnum);
for i=1:samplesize
   img=reshape(imgs(i,:),128,128);
   D=tpm(img); 
   tmp=D(:,:,1);
   f=tmp(points);
   features(i,:)=f';
end