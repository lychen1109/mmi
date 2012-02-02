function cri=fldcri(label,feat)
%calculate discriminance of every single feature

featau=feat(label==1,:);
featsp=feat(label==0,:);
mean_au=mean(featau);
mean_sp=mean(featsp);
var_au=var(featau);
var_sp=var(featsp);
cri=(mean_au-mean_sp).^2./(var_au+var_sp);
