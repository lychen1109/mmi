function [SVs,SVsu,SVsc,Y,Yu,Yc,alphac,alphau]=modelparse(model,C)
%modelparse extract useful info from svm model

SVs=model.SVs;
sv_coef=model.sv_coef;
Y=sign(sv_coef);
idxc=sv_coef>C-eps | sv_coef<-C+eps;
idxu=sv_coef<C-eps & sv_coef>-C+eps;
alphac=abs(sv_coef(idxc));
alphau=abs(sv_coef(idxu));
Yc=sign(sv_coef(idxc));
Yu=sign(sv_coef(idxu));
SVsu=SVs(idxu,:);
SVsc=SVs(idxc,:);

