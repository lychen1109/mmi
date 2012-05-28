function [scoreau,scoresp]=randomfeatgen(auimages,spimages)
%Generate 200 random samples from authentic images and spliced images, all
%the features are PCA processed to only two features

num_sample=200;
T=3;
numau=size(auimages,1);
numsp=size(spimages,1);
randidx=randperm(numau);
auimages=auimages(randidx(1:num_sample),:);
randidx=randperm(numsp);
spimages=spimages(randidx(1:num_sample),:);

tmau=transmatgen(auimages,T);
numpoint=sum(sum(tmau(:,:,1)));
tmau=tmau/numpoint;
tmsp=transmatgen(spimages,T);
tmsp=tmsp/numpoint;

featau=reshape(tmau,(2*T+1)^2,num_sample)';
featsp=reshape(tmsp,(2*T+1)^2,num_sample)';
[~,scoreau]=princomp(featau);
[~,scoresp]=princomp(featsp);
scoreau=scoreau(:,1:2);
scoresp=scoresp(:,1:2);


