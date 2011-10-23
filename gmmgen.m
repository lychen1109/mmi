function gm=gmmgen(feat,k)
%gmm model generation

idx=kmeans(feat,k,'replicates',20);
gm=gmdistribution.fit(feat,k,'start',idx,'covtype','diagonal','SharedCov',false);