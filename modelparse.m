function modelstruct=modelparse(model,C)
%modelparse extract info from svm model into struct

SVs=model.SVs;
sv_coef=model.sv_coef;
idxc=abs(sv_coef)>C-1e-4;
idxu=abs(sv_coef)<=C-1e-4;
alphac=abs(sv_coef(idxc));
alphau=abs(sv_coef(idxu));
Yc=sign(sv_coef(idxc));
Yu=sign(sv_coef(idxu));
SVsu=SVs(idxu,:);
SVsc=SVs(idxc,:);
SVs=[SVsc;SVsu];
Y=[Yc;Yu];

rho=model.rho;

modelstruct.SVs=SVs;
modelstruct.SVsu=SVsu;
modelstruct.SVsc=SVsc;
modelstruct.Y=Y;
modelstruct.Yc=Yc;
modelstruct.Yu=Yu;
modelstruct.alphau=alphau;
modelstruct.alphac=alphac;
modelstruct.rho=rho;
