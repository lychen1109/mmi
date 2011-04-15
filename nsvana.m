function [nSV,bSV]=nsvana(label,feat,cvp,history)
%printf nSV of histories

thetas=history.thetas;
N=size(thetas,1);
nSV=zeros(N,1);
bSV=zeros(N,1);
for i=1:N
    theta=thetas(i,:);
    modelstruct=mysvmfun(label(cvp.training),feat(cvp.training,:),label(cvp.test),feat(cvp.test,:),theta);
    SVs=modelstruct.SVs;
    SVsc=modelstruct.SVsc;
    nSV(i)=size(SVs,1);
    bSV(i)=size(SVsc,1);
end
